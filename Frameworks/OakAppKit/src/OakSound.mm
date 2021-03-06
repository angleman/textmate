#import "OakSound.h"
#import <io/path.h>

void OakPlayUISound (OakSoundIdentifier aSound)
{
	struct sound_info_t
	{
		OakSoundIdentifier name;
		std::string path;
		bool initialized;
		SystemSoundID sound;
	};

	static sound_info_t sounds[] =
	{
		{ OakSoundDidTrashItemUISound,         "dock/drag to trash.aif"   },
		{ OakSoundDidMoveItemUISound,          "system/Volume Mount.aif"  },
		{ OakSoundDidCompleteSomethingUISound, "system/burn complete.aif" }
	};

	for(size_t i = 0; i < sizeofA(sounds); ++i)
	{
		if(sounds[i].name == aSound)
		{
			if(!sounds[i].initialized)
			{
				std::string const path_10_6 = path::join("/System/Library/Components/CoreAudio.component/Contents/Resources/SystemSounds", sounds[i].path);
				std::string const path_10_7 = path::join("/System/Library/Components/CoreAudio.component/Contents/SharedSupport/SystemSounds", sounds[i].path);
				std::string const path = path::exists(path_10_7) ? path_10_7 : path_10_6;

				CFURLRef url = CFURLCreateFromFileSystemRepresentation(kCFAllocatorDefault, (UInt8 const*)path.data(), path.size(), false);
				AudioServicesCreateSystemSoundID(url, &sounds[i].sound);
				CFRelease(url);
				sounds[i].initialized = true;
			}

			if(sounds[i].sound)
				AudioServicesPlaySystemSound(sounds[i].sound);

			break;
		}
	}
}
