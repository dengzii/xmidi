import 'dart:io';

import 'package:xmidi/xmidi.dart';

void main() {
  // Open a file containing midi data
  var file = File(r"test.mid");

  // Construct a midi reader
  var reader = MidiReader();

  // Parse midi directly from file. You can also use parseMidiFromBuffer to directly parse List<int>
  MidiFile parsedMidi = reader.parseMidiFromFile(file);

  for (var track in parsedMidi.tracks) {
    print("==== Track ${track.trackName} ====");
    int index = 0;
    for (var event in track) {
      index++;
      if (event is ProgramChangeMidiEvent) {
        print("${event.programNumber} ${index}");
        // print("${event.tick} ${event.noteNumber} ${event.duration}");
      } else if (event is NoteOnEvent || event is NoteOffEvent) {
        //
      } else {
        print(event);
      }
    }
  }
}
