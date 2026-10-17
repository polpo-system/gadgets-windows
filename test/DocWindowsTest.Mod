MODULE DocWindowsTest;  (** DocWindowsTest.Run: a text document in a window of its own, closed again; needs X11 (DISPLAY) *)

IMPORT Files, Documents, Windows, DocWindows, Out := out;

VAR fails, checks: LONGINT;

PROCEDURE Check(what: ARRAY OF CHAR; ok: BOOLEAN);
BEGIN
  INC(checks);
  IF ~ok THEN INC(fails); Out.String("FAIL "); Out.String(what); Out.Ln END
END Check;

PROCEDURE Run*;
VAR f: Files.File; R: Files.Rider; D: Documents.Document; V: Windows.Window; s: ARRAY 16 OF CHAR; i: INTEGER;
BEGIN
  fails := 0; checks := 0;
  f := Files.New("zq_test.Text"); Files.Set(R, f, 0);
  s := "hello, window"; i := 0; WHILE s[i] # 0X DO Files.Write(R, s[i]); INC(i) END;
  Files.Write(R, 0AX); Files.Register(f);
  D := Documents.Open("zq_test.Text");
  Check("zq_test.Text opened", (D # NIL) & (D.dsc # NIL));
  IF (D # NIL) & (D.dsc # NIL) THEN
    V := DocWindows.Open(D);
    Check("a window of its own", V # NIL);
    IF V # NIL THEN
      Check("below the screen", V.Y < 0);
      Check("the document fills it", (D.X = V.X) & (D.Y = V.Y) & (D.W = V.W) & (D.H = V.H));
      Windows.Close(V); Check("closed", V.state = 0)
    END
  END;
  Out.String("DocWindowsTest: "); Out.Int(checks, 0); Out.String(" checks, "); Out.Int(fails, 0); Out.String(" failed"); Out.Ln
END Run;

END DocWindowsTest.
