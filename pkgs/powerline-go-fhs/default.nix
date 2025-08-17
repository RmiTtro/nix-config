{ writers }:
writers.writePython3Bin "powerline-go-fhs" {
  libraries = [ ];
} ''
  import os
  import json

  # Icon origin: search ef81 in https://www.nerdfonts.com/cheat-sheet
  FHS_SEGMENT = {
      "Name": "fhs",
      "Content": "\uef81 FHS",
      "Foreground": 166,
      "Background": 214
  }

  # powerline-go expect a JSON list of segments in the output
  if os.environ.get("FHS", "0") == "1":
      print(json.dumps([FHS_SEGMENT]))
  else:
      print(json.dumps([]))
''