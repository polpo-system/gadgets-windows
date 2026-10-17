MODULE DocWindows;  (** polpo: gadget documents in X11 windows of their own *)

(** DocWindows.OpenDoc name ~ opens the document name (a panel, a picture, a text, ...) in a window
  of its own, as large as the document and with its file name as the title. The window looks like the
  windows of the other programs: the window manager moves it, and its close button closes it.
  Programs call Open(D). The windows are those of the module Windows of polpo (X11 only). *)

IMPORT Display, Texts, Oberon, Documents, Windows;

VAR W: Texts.Writer;

(** Open the document D in a window of its own, as large as D (at least 64 x 32, at most the
  screen); NIL: no window *)
PROCEDURE Open*(D: Documents.Document): Windows.Window;
VAR w, h, i, j: INTEGER; title: ARRAY 128 OF CHAR;
BEGIN
  i := 0; j := 0;  (* the title: the name without its directory *)
  WHILE (i < LEN(D.name)) & (D.name[i] # 0X) DO IF D.name[i] = "/" THEN j := i + 1 END; INC(i) END;
  i := 0; WHILE (D.name[j] # 0X) & (i < LEN(title) - 1) DO title[i] := D.name[j]; INC(i); INC(j) END;
  title[i] := 0X;
  w := D.W; h := D.H;
  IF w < 64 THEN w := 64 ELSIF w > Display.Width THEN w := Display.Width END;
  IF h < 32 THEN h := 32 ELSIF h > Display.Height THEN h := Display.Height END;
  RETURN Windows.Open(D, title, w, h)
END Open;

(** DocWindows.OpenDoc name ~  the document name in a window of its own; ^ takes the selected name *)
PROCEDURE OpenDoc*;
VAR S: Texts.Scanner; T: Texts.Text; beg, end, time: LONGINT; D: Documents.Document;
BEGIN
  Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos); Texts.Scan(S);
  IF (S.class = Texts.Char) & (S.c = "^") THEN
    Oberon.GetSelection(T, beg, end, time);
    IF time >= 0 THEN Texts.OpenScanner(S, T, beg); Texts.Scan(S) END
  END;
  IF S.class IN {Texts.Name, Texts.String} THEN
    D := Documents.Open(S.s);
    IF (D = NIL) OR (D.dsc = NIL) THEN Texts.WriteString(W, Documents.errMsg)
    ELSIF Open(D) = NIL THEN Texts.WriteString(W, "DocWindows.OpenDoc: no window (X11 only, at most 16, as large as the screen)")
    END
  ELSE Texts.WriteString(W, "usage: DocWindows.OpenDoc name ~  a document in a window of its own")
  END;
  IF W.buf.len > 0 THEN Texts.WriteLn(W); Texts.Append(Oberon.Log, W.buf) END
END OpenDoc;

BEGIN Texts.OpenWriter(W)
END DocWindows.
