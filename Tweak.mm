#import <substrate.h>

static CFURLRef (*original_CFBundleCopyResourceURLForLocalization)(CFBundleRef bundle, CFStringRef resourceName, CFStringRef resourceType, CFStringRef subDirName, CFStringRef localizationName);

CFURLRef replaced_CFBundleCopyResourceURLForLocalization(CFBundleRef bundle, CFStringRef resourceName, CFStringRef resourceType, CFStringRef subDirName, CFStringRef localizationName) 
{
	CFURLRef orig_URL = original_CFBundleCopyResourceURLForLocalization(bundle, resourceName, resourceType, subDirName, localizationName);
	if ([[(NSURL *)orig_URL absoluteString] isEqualToString:@"file://localhost/System/Library/Frameworks/AddressBook.framework/English.lproj/ABContactSections.plist"])
	{
		CFRelease(orig_URL);
		return CFURLCreateWithString(kCFAllocatorDefault, (CFStringRef)@"file://localhost/Library/Application%20Support/ABHebrewFix/replaced_Hebrew_Fix_ABContactSections.plist", NULL);
	}
	return orig_URL;
}

%ctor 
{ 
	MSHookFunction((void *)CFBundleCopyResourceURLForLocalization, (void *)replaced_CFBundleCopyResourceURLForLocalization, (void **)&original_CFBundleCopyResourceURLForLocalization); 
}