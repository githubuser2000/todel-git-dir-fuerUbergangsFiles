program ClipboardLogger;

{$mode objfpc}{$H+}

uses
  Classes, SysUtils, Process, SHA2, DateUtils;

const
  LOG_FILE = '/home/dein_user/clipboard.log';
  INTERVAL = 2; // Sekunden

function GetClipboard: string;
var
  OutputLines: TStringList;
begin
  OutputLines := TStringList.Create;
  try
    RunCommand('wl-paste', ['-n'], OutputLines);
    Result := Trim(OutputLines.Text);
  finally
    OutputLines.Free;
  end;
end;

function HashString(const S: string): string;
var
  Digest: TSHA2Digest;
begin
  Digest := SHA256String(S);
  Result := '';
  for var B in Digest do
    Result := Result + IntToHex(B, 2);
end;

procedure LogClipboard(const Content: string);
var
  F: TextFile;
  Timestamp: string;
begin
  Timestamp := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now);
  AssignFile(F, LOG_FILE);
  if FileExists(LOG_FILE) then
    Append(F)
  else
    Rewrite(F);
  try
    Writeln(F, '[' + Timestamp + ']');
    Writeln(F, Content);
    Writeln(F);
  finally
    CloseFile(F);
  end;
end;

var
  LastHash, CurrentHash, Content: string;
begin
  LastHash := '';
  while True do
  begin
    Content := GetClipboard;
    if Content <> '' then
    begin
      CurrentHash := HashString(Content);
      if CurrentHash <> LastHash then
      begin
        LogClipboard(Content);
        Writeln('Neuer Clipboard-Inhalt geloggt: ', Copy(Content, 1, 30), '...');
        LastHash := CurrentHash;
      end;
    end;
    Sleep(INTERVAL * 1000);
  end;
end.

