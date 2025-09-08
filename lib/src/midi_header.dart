class MidiHeader {
  final int numTracks;

  /// 0:  single track contains multiple channels
  /// 1:  multiple simultaneous  tracks, each contains a single channel
  /// 2:   multiple independent tracks
  final int format;
  final int? framesPerSecond;
  final int? ticksPerBeat;
  final int? ticksPerFrame;
  final int? timeDivision;

  MidiHeader({
    required this.format,
    required this.numTracks,
    this.framesPerSecond,
    this.ticksPerBeat,
    this.ticksPerFrame,
    this.timeDivision,
  });
}
