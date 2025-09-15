class MidiUtils {
  static final noteRegex = RegExp(r'^([C|D|E|F|G|A|B]#?)(\d+)$');

  static final chromatic = [
    'C',
    'C#',
    'D',
    'D#',
    'E',
    'F',
    'F#',
    'G',
    'G#',
    'A',
    'A#',
    'B',
  ];
  static final GMInstrumentList = [
    "acoustic grand piano",
    "bright acoustic piano",
    "electric grand piano",
    "honky-tonk piano",
    "rhodes piano",
    "chorused piano",
    "harpsichord",
    "clavinet",
    "celeste",
    "glockenspiel",
    "music box",
    "vibraphone",
    "marimba",
    "xylophone",
    "tubular bells",
    "dulcimer",
    "hammond organ",
    "percussive organ",
    "rock organ",
    "church organ",
    "reed organ",
    "accordion",
    "harmonica",
    "tango accordion",
    "nylon guitar",
    "steel guitar",
    "jazz guitar",
    "clean guitar",
    "muted guitar",
    "overdriven guitar",
    "distortion guitar",
    "guitar harmonics",
    "acoustic bass",
    "fingered electric bass",
    "picked electric bass",
    "fretless bass",
    "slap bass 1",
    "slap bass 2",
    "synth bass 1",
    "synth bass 2",
    "violin",
    "viola",
    "cello",
    "contrabass",
    "tremolo strings",
    "pizzcato strings",
    "orchestral harp",
    "timpani",
    "string ensemble 1",
    "string ensemble 2",
    "synth strings 1",
    "synth strings 1",
    "choir aahs",
    "voice oohs",
    "synth voices",
    "orchestra hit",
    "trumpet",
    "trombone",
    "tuba",
    "muted trumpet",
    "frenc horn",
    "brass section",
    "syn brass 1",
    "synth brass 2",
    "soprano sax",
    "alto sax",
    "tenor sax",
    "baritone sax",
    "oboe",
    "english horn",
    "bassoon",
    "clarinet",
    "piccolo",
    "flute",
    "recorder",
    "pan flute",
    "bottle blow",
    "shakuhachi",
    "whistle",
    "ocarina",
    "square wave",
    "saw wave",
    "calliope lead",
    "chiffer lead",
    "charang lead",
    "voice lead",
    "fifths lead",
    "brass lead",
    "newage pad",
    "warm pad",
    "polysyn pad",
    "choir pad",
    "bowed pad",
    "metallic pad",
    "halo pad",
    "sweep pad",
    "rain",
    "soundtrack",
    "crystal",
    "atmosphere",
    "brightness",
    "goblins",
    "echoes",
    "sci-fi",
    "sitar",
    "banjo",
    "shamisen",
    "koto",
    "kalimba",
    "bagpipes",
    "fiddle",
    "shanai",
    "tinkle bell",
    "agogo",
    "steel drums",
    "woodblock",
    "taiko drum",
    "melodoc tom",
    "synth drum",
    "reverse cymbal",
    "guitar fret noise",
    "breath noise",
    "seashore",
    "bird tweet",
    "telephone ring",
    "helicopter",
    "applause",
    "gunshot"
  ];

  /// Get the note name (in scientific notation) of the given midi number
  /// where C1 is 36
  ///
  /// @see https://computermusicresource.com/midikeys.html
  ///
  /// This method doesn't take into account diatonic spelling. Always the same
  /// pitch class is given for the same midi number.
  static String midiToNote(int midi) {
    var name = MidiUtils.chromatic[midi % 12];
    var oct = ((midi - 24) / 12).floor();
    return '$name$oct';
  }

  static String getInstrumentName(int instrument) {
    return MidiUtils.GMInstrumentList[instrument];
  }

  static int noteToMidi(String note) {
    final parsed = MidiUtils.noteRegex.firstMatch(note);

    if (parsed == null || parsed.groupCount != 2) {
      throw Exception("Invalid note format");
    }

    final chromatic = parsed.group(1)!;
    final oct = int.parse(parsed.group(2)!);
    final chromaticIndex = MidiUtils.chromatic.indexOf(chromatic);

    return chromaticIndex + oct * 12 + 24;
  }
}
