import 'dart:collection';

import 'midi_events.dart';
import 'midi_header.dart';

class MidiFile {
  final List<MidiTrack> tracks;
  final MidiHeader header;
  final isAbsoluteTime = true;

  MidiFile(this.tracks, this.header);

  int getFileDurationTicks() {
    var maxTick = 0;
    for (var track in tracks) {
      maxTick = track.last.tick > maxTick ? track.last.tick : maxTick;
    }
    return maxTick;
  }

  /// Did not consider time signature and tempo changes
  double getTimeInSeconds() {
    final tempo = 120.0;
    return getFileDurationTicks() / (header.ticksPerBeat! * tempo / 60);
  }
}

class MidiTrack with ListMixin<MidiEvent> {
  final List<MidiEvent> events;
  String trackName = '';
  TimeSignatureEvent? timeSignature;

  @override
  int length;

  MidiTrack({required this.events}) : length = events.length;

  @override
  MidiEvent operator [](int index) => events[index];

  @override
  void operator []=(int index, MidiEvent value) => events[index] = value;
}
