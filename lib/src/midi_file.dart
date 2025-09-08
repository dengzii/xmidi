import 'dart:collection';
import 'dart:io';

import 'package:xmidi/xmidi.dart';

class MidiFile {
  final List<MidiTrack> tracks;
  final MidiHeader header;
  final isAbsoluteTime = true;

  MidiFile(this.tracks, this.header);

  /// [splitTracks]  splits the single track into multiple tracks
  static MidiFile readFromFile(String path, {bool splitTracks = true}) {
    final rad = MidiReader();
    final file = rad.parseMidiFromFile(File(path));
    if (file.header.format == 0 && splitTracks && file.tracks.length == 1) {
      final split = file.tracks.first.split();
      file.tracks.clear();
      file.tracks.addAll(split);
    }
    return file;
  }

  int getFileDurationTicks() {
    var maxTick = 0;
    for (var track in tracks) {
      maxTick = track.last.tick > maxTick ? track.last.tick : maxTick;
    }
    return maxTick;
  }

  Future writeToFile(String path) async {
    final wrt = MidiWriter();
    wrt.writeMidiToFile(this, File(path));
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

  List<MidiTrack> split() {
    final splitTracks = <int, List<MidiEvent>>{};
    int minChan = 99999;
    for (var event in events) {
      int channel = -1;
      if (event is NoteOnEvent) {
        channel = event.channel;
      } else if (event is NoteOffEvent) {
        channel = event.channel;
      } else if (event is ProgramChangeMidiEvent) {
        channel = event.channel;
      } else if (event is ControllerEvent) {
        channel = event.channel;
      } else if (event is ChannelAfterTouchEvent) {
        channel = event.channel;
      } else if (event is PitchBendEvent) {
        channel = event.channel;
      } else if (event is NoteAfterTouchEvent) {
        channel = event.channel;
      } else if (event is ChannelPrefixEvent) {
        channel = event.channel;
      }
      if (channel < minChan && channel != -1) {
        minChan = channel;
      }
      splitTracks[channel] ??= [];
      splitTracks[channel]!.add(event);
    }
    final deft = splitTracks.remove(-1) ?? [];
    splitTracks[minChan]?.addAll(deft);
    final result =
        splitTracks.entries.map((es) => MidiTrack(events: es.value)).toList();
    for (var track in result) {
      int deltaTick = 0;
      int preAbsTick = 0;
      track.sort((a, b) => a.tick.compareTo(b.tick));
      for (var event in track) {
        if (event.tick == preAbsTick) {
          event.deltaTime = 0;
        } else {
          deltaTick = event.tick - preAbsTick;
          event.deltaTime = deltaTick;
        }
        preAbsTick = event.tick;
      }
    }
    return result;
  }
}
