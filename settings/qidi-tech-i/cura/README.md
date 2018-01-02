# Qidi Tech I Cura Definitions

These are definition files to use the Qidi Tech I with recent versions of Cura (I'm using them with Cura 3.1).

Older versions of Cura may be better suited to something like https://github.com/markwal/Cura-FFCP.

The printer definition uses [Cura's definition for the MakerBot Replicator][makerbotreplicator.def.json] as a base, with the following adjustments:

[makerbotreplicator.def.json]: https://github.com/Ultimaker/Cura/blob/master/resources/definitions/makerbotreplicator.def.json

## Print bed origin

`machine_center_is_zero` is set to `true`. From what I've caught from sources like [this](https://forum.simplify3d.com/viewtopic.php?f=8&t=2366#p9682) and [this](https://groups.google.com/d/msg/makerbot/VoDhtt9k2No/UCplbcsYJHgJ), all MakerBot-family machines use the center of the build plate as zero (and as such, it's kind of weird that this is a change from Cura's stock profile for the Replicator, which has this set to `false`).

## Dual extruders

I've set the extruder count to 2, with extruders defined for each rail: due to the way the extruders are numbered in the printer's firmware, the "Right Extruder" is presented on the *left* in Cura's UI, and vice versa. Attempts to re-number the extruders for the UI [led to problems][Ultimaker/Cura#3064], so, until this issue gets sorted out, we'll just have to live with it.

[Ultimaker/Cura#3064]: https://github.com/Ultimaker/Cura/issues/3064

Even without the proper order defined, the extruders are labeled "Right Extruder" and "Left Extruder" (presented in menus and tooltips), to clarify which is which. (It can still be confusing which extruder "extruder 1" refers to, as the UI presents them as "1" and "2", while the code describes them as "0" and "1".)

## Start and End Custom G-code

I've copied the start and end G-code procedures from [Mark Walker's Cura definitions for the FlashForge Creator Pro][Cura-FFCP], with a few GPX-oriented annotations (such as an explicit `;@flavor reprap` line to ensure GPX interprets the code as RepRap as described below) that will mostly only be useful if you introduce more complexity into your G-code before passing it to GPX (eg. adding macros, as demonstrated in the [GPX examples][]).

[Cura-FFCP]: https://github.com/markwal/Cura-FFCP
[GPX examples]: https://github.com/markwal/GPX/tree/master/examples

## Build area

I tweaked the build plate size from 145x225 to 148x227, which matches the dimensions of GPX's Replicator 1 Dual definition (and other citations I've seen of the Qidi Tech I build size).

## RepRap-flavor G-code

The `machine_gcode_flavor` is set to the base default flavor for Cura, `RepRap (Marlin/Sprinter)`. While the printer *is* ultimately taking commands equivalent to MakerBot-flavor G-code, the "MAKERBOT" profile in CuraEngine is [designed for translation through the proprietary x3g converter from *MakerWare*][requires MakerWare] (and mostly only causes a few functions to be gimped, such as [resetting extrusion value][resetExtrusionValue]).

[requires MakerWare]: https://github.com/Ultimaker/CuraEngine/blob/c60f21b0d9accb7899b2b32c00bbe26783543c9e/src/settings/settings.h#L48
[resetExtrusionValue]: https://github.com/Ultimaker/CuraEngine/blob/4463c7254fc942fffc842c7d4c9a2c11c57be70c/src/gcodeExport.cpp#L498-L512

Meanwhile, [GPX][] (which is most likely how you'll be translating the code from Cura, either via [the GPX plugin in Cura][X3GWriter] or through [OctoPrint's GPX plugin][OctoPrint-GPX]) [expects RepRap-flavor code by default][firstTime reprapFlavor], and has only two real differences between the two that I can discern, [apparently added to accomodate the long-obsolete ReplicatorG][f3dfa55], and neither of which suggest that using MakerBot-flavored G-code would be superior:

[GPX]: https://github.com/markwal/GPX
[X3GWriter]: https://github.com/Ghostkeeper/X3GWriter
[OctoPrint-GPX]: https://github.com/markwal/OctoPrint-GPX
[firstTime reprapFlavor]: https://github.com/markwal/GPX/blob/master/src/gpx/gpx.c#L357
[f3dfa55]: https://github.com/markwal/GPX/commit/f3dfa55641b35120a7283c266311972620bf7cc4

- The M109 command [only has distinct behavior for RepRap-flavor G-code][GPX M109], and is [coerced to the same behavior as M140][fall through to M140] for MakerBot-flavored G-code.
- The M106 and M107 commands [(maybe?)](https://github.com/markwal/GPX/blob/461f94b4ec10a8cdf17d067419da6c6affa42240/src/pymodule/gpxmodule.c#L671) take [different code paths][fan paths] to toggling the cooling turbofan, though even following this [through the Sailfish firmware][Sailfish commands], [all the way][Sailfish setExtra], [through each path's][Sailfish setFan] [final operations][Sailfish enableFan], I can't conclusively explain the distinction between the two ends, or why you'd have it.

[GPX M109]: https://github.com/markwal/GPX/blob/0cfa00807e52bc81f67447968794706ffd6a0eb9/src/gpx/gpx.c#L5427
[fall through to M140]: https://github.com/markwal/GPX/blob/0cfa00807e52bc81f67447968794706ffd6a0eb9/src/gpx/gpx.c#L5487
[fan paths]: https://github.com/markwal/GPX/blob/0cfa00807e52bc81f67447968794706ffd6a0eb9/src/gpx/gpx.c#L5299-L5375
[Sailfish commands]: https://github.com/jetty840/Sailfish-MightyBoardFirmware/blob/2d2425061229613bd6059d9055e6ac390914653a/firmware/src/MightyBoard/Motherboard/Command.cc#L934-L939
[Sailfish setExtra]: https://github.com/jetty840/Sailfish-MightyBoardFirmware/blob/7040951d3f217b0964bf3199a04568a0a7386aab/firmware/src/MightyBoard/Motherboard/Motherboard.cc#L1007-L1046
[Sailfish setFan]: https://github.com/jetty840/Sailfish-MightyBoardFirmware/blob/7040951d3f217b0964bf3199a04568a0a7386aab/firmware/src/MightyBoard/shared/ExtruderBoard.cc#L75-L77
[Sailfish enableFan]: https://github.com/jetty840/Sailfish-MightyBoardFirmware/blob/7040951d3f217b0964bf3199a04568a0a7386aab/firmware/src/MightyBoard/shared/CoolingFan.cc#L54-L56

In any case, when GPX interprets the incoming code as RepRap-flavored, it follows the same code path as the commands [Cura would output for MakerBot-flavored G-code][writeFanCommand], [M126 and M127][GPX M126 and M127] (setting the fan via [Action 13, "set extra output" / "set valve"][GPX set_valve]). In other words, the only way to trigger the code path in GPX to set the fan for MakerBot-flavored G-code (using [Action 12, "set fan"][GPX set_fan]) would be to output RepRap-flavored G-code from Cura and have GPX *explicitly* interpret it as MakerBot-flavored.

[writeFanCommand]: https://github.com/Ultimaker/CuraEngine/blob/4463c7254fc942fffc842c7d4c9a2c11c57be70c/src/gcodeExport.cpp#L991-L1010
[GPX M126 and M127]: https://github.com/markwal/GPX/blob/0cfa00807e52bc81f67447968794706ffd6a0eb9/src/gpx/gpx.c#L5537-L5563
[GPX set_valve]: https://github.com/markwal/GPX/blob/0cfa00807e52bc81f67447968794706ffd6a0eb9/src/gpx/gpx.c#L1567-L1594
[GPX set_fan]: https://github.com/markwal/GPX/blob/0cfa00807e52bc81f67447968794706ffd6a0eb9/src/gpx/gpx.c#L1527-L1548

Explicitly processing RepRap-flavored G-code as MakerBot-flavored G-code like this would be a bad idea, though, because the last remaining difference in Cura's output is in [the output of tool-switching commands][startExtruder]. When interpreting commands as RepRap-flavor, GPX handles T tool-change commands like their M135 tool-changing equivalents: however, when interpreting G-code as *MakerBot-flavored*, it emulates [the forgetful behavior of T commands][revert tool selection], and other X3G translators (such as MatterControl's proprietary X3GDriver, when I last used it in late December 2017) will run into issues where the extruder will change, but the firmware's toolhead offsets won't be applied because [the "change tool" command doesn't fire][changeToolIndex] (so filament just gets extruded *next to* where it's supposed to go, as the other extruder traces the correct path).

[startExtruder]: https://github.com/Ultimaker/CuraEngine/blob/4463c7254fc942fffc842c7d4c9a2c11c57be70c/src/gcodeExport.cpp#L877-L884
[revert tool selection]: https://github.com/markwal/GPX/blob/0cfa00807e52bc81f67447968794706ffd6a0eb9/src/gpx/gpx.c#L4615-L4616
[changeToolIndex]: https://github.com/jetty840/Sailfish-MightyBoardFirmware/blob/2d2425061229613bd6059d9055e6ac390914653a/firmware/src/MightyBoard/Motherboard/Command.cc#L1505


[RepRapFlavorParser]: https://github.com/Ultimaker/Cura/blob/0f944c094d88fe87c8f34a21018a2227ee9196f0/plugins/GCodeReader/RepRapFlavorParser.py
[EGCodeFlavor::REPRAP]: https://github.com/Ultimaker/CuraEngine/blob/4463c7254fc942fffc842c7d4c9a2c11c57be70c/src/gcodeExport.cpp
[GPX M commands]: https://github.com/markwal/GPX/blob/0cfa00807e52bc81f67447968794706ffd6a0eb9/src/gpx/gpx.c#L4952-L5809
[CuraEngine M203]: https://github.com/Ultimaker/CuraEngine/blob/4463c7254fc942fffc842c7d4c9a2c11c57be70c/src/gcodeExport.cpp#L1129-L1136
[CuraEngine M204]: https://github.com/Ultimaker/CuraEngine/blob/4463c7254fc942fffc842c7d4c9a2c11c57be70c/src/gcodeExport.cpp#L1051-L1102
[writeJerk]: https://github.com/Ultimaker/CuraEngine/blob/4463c7254fc942fffc842c7d4c9a2c11c57be70c/src/gcodeExport.cpp#L1113-L1118
[RepRap G-code]: http://reprap.org/wiki/G-code
[Ultimaker/Cura#2919 (comment)]: https://github.com/Ultimaker/Cura/issues/2919#issuecomment-354684488

**TL;DR:** I spent five hours exhaustively searching the codepaths involved and can conclusively assert that **different flavors of G-code will almost certainly not impact print behavior in any way whatsoever**. The only place where it *might* have an impact is if you *explicitly mess it up*, and even *then* it'll probably be okay.
