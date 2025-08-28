import 'dart:io';

import 'package:xmidi2/xmidi2.dart';

void main() {
  // Open a file containing midi data
  var file = File(r"C:\Users\dengz\Downloads\test2.mid");

  // Construct a midi reader
  var reader = MidiReader();

  // Parse midi directly from file. You can also use parseMidiFromBuffer to directly parse List<int>
  MidiFile parsedMidi = reader.parseMidiFromFile(file);

  print(
      'ticks=${parsedMidi.getFileDurationTicks()}, sec=${parsedMidi.getTimeInSeconds()}');
  for (var track in parsedMidi.tracks) {
    print("==== Track ${track.trackName} ====");
    for (var event in track) {
      if (event is NoteOnEvent) {
        // print("${event.tick} ${event.noteNumber} ${event.duration}");
      }
    }
  }
}
