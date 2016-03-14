MODULE FixName; (*$MAIN*)
IMPORT
  CmdLine, IO := Console, Convert := Strings, Files, KolFiles, Ignore,
  SYSTEM, LibC;

VAR
  pathname, oldname, newname: CmdLine.String;

PROCEDURE ReplaceHex (IN s: ARRAY OF CHAR; VAR res: ARRAY OF CHAR): BOOLEAN;
VAR
  num, i, j: INTEGER; hexNum: ARRAY 3 OF CHAR;
BEGIN
  i := 0; j := 0; hexNum[2] := 0X;
  LOOP
    IF (s[i] = "%") THEN
      IF i+2 < LEN(s) THEN
        hexNum[0] := s[i+1]; hexNum[1] := s[i+2];
        num := Convert.HexToInt(hexNum);
        IF (num >= 0) & (hexNum[1] # 0X) THEN
          res[j] := CHR(num);
        ELSE
          EXIT
        END;
        INC(i, 2);
      ELSE
        EXIT
      END;
    ELSE
      res[j] := s[i]; IF s[i] = 0X THEN RETURN TRUE END;
    END;
    INC(j); IF j = LEN(res) THEN DEC(j); EXIT END;
    INC(i); IF i = LEN(s) THEN res[j] := 0X; RETURN TRUE END;
  END;
  res[j] := 0X; RETURN FALSE
END ReplaceHex;

BEGIN
  IO.WriteStrLn("FixName v1.01 - a tool to fix UTF-8 & Hex file names");
  IO.WriteStrLn("(c) 2016 VEDAsoft Oberon Club - http://zx.oberon2.ru");
  IO.WriteLn;
  IF CmdLine.ParamCount # 1 THEN
    IO.WriteStrLn("  Usage: FixName pathname");
    IO.WriteStrLn('         FixName "path name with spaces"');
    HALT(1)
  END;
  CmdLine.GetParam(1, pathname);
  IF (KolFiles.ExtractFilePath(pathname, newname)) & (newname # "") THEN
    IF LibC.chdir(SYSTEM.VAL(LibC.PtrSTR, SYSTEM.ADR(newname))) # 0 THEN
      IO.WriteStrLn("Bad path"); HALT(1)
    END;
  END;
  Ignore.Bool( KolFiles.ExtractFileName(pathname, oldname) );
  IF ~ ReplaceHex(oldname, newname) THEN newname := oldname END;
  IF Convert.Utf8ToWin1251(newname, pathname) THEN newname := pathname END;
  IF oldname # newname THEN
    IF Files.RenameFile(oldname, newname) THEN HALT(0) END;
    IO.WriteStrLn("Couldn't rename"); HALT(1)
  ELSE
    IO.WriteStrLn("Couldn't convert"); HALT(1)
  END;
END FixName.
