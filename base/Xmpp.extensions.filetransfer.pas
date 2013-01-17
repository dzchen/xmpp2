unit Xmpp.extensions.filetransfer;

interface
uses
  XmppUri,Element,SysUtils,Time;
type
  TRange=class(TElement)
  const
  TagName='range';
  private
    function FGetOffset:LongInt;
    procedure FSetOffset(value:LongInt);
    function FGetLen:LongInt;
    procedure FSetLen(value:LongInt);
  public
    constructor Create;overload;override;
    constructor Create(offset,len:LongInt);overload;
    property Offset:LongInt read FGetOffset write FSetOffset;
    property Len:LongInt read FGetLen write FSetLen;
    class function GetConstTagName():string;override;
  end;
  TFile=class(TElement)
  const
  TagName='file';
  private
    function FGetFileName:string;
    procedure FSetFileName(value:string);
    function FGetSize:Int64;
    procedure FSetSize(value:Int64);
    function FGetHash:string;
    procedure FSetHash(value:string);
    function FGetDate:TDateTime;
    procedure FSetDate(value:TDateTime);
    function FGetDescription:string;
    procedure FSetDescription(value:string);
    function FGetRange:TRange;
    procedure FSetRange(value:TRange);
  public
    constructor Create;overload;override;
    constructor Create(name:string;size:Int64);overload;
    property FileName:string read FGetFileName write FSetFileName;
    property Size:Int64 read FGetSize write FSetSize;
    property Hash:string read FGetHash write FSetHash;
    property Date:TDateTime read FGetDate write FSetDate;
    property Description:string read FGetDescription write FSetDescription;
    property Range:TRange read FGetRange write FSetRange;
    class function GetConstTagName():string;override;
  end;

implementation

{ TRange }

constructor TRange.Create;
begin
  inherited;
  Name:='range';
  Namespace:=XMLNS_SI_FILE_TRANSFER;
end;

constructor TRange.Create(offset, len: Integer);
begin
self.Create;
self.Offset:=offset;
self.Len:=len;
end;

function TRange.FGetLen: LongInt;
begin
  Result:=StrToInt64(GetAttribute('length'));
end;

function TRange.FGetOffset: LongInt;
begin
  Result:=StrToInt64(GetAttribute('offset'));
end;

procedure TRange.FSetLen(value: Integer);
begin
  SetAttribute('length',IntToStr(value));
end;

procedure TRange.FSetOffset(value: Integer);
begin
  SetAttribute('offset',IntToStr(value));
end;

class function TRange.GetConstTagName: string;
begin
  Result:=TagName+'-'+XMLNS_SI_FILE_TRANSFER;
end;

{ TFile }

constructor TFile.Create(name: string; size: Int64);
begin
  self.Create;
  self.FileName:=name;
  self.Size:=size;
end;

constructor TFile.Create;
begin
  inherited;
  Name:='file';
  namespace:=XMLNS_SI_FILE_TRANSFER;
end;

function TFile.FGetDate: TDateTime;
begin
  Result:=JabberToDateTime(GetAttribute('date'));
end;

function TFile.FGetDescription: string;
begin
  Result:=GetTag('desc');
end;

function TFile.FGetFileName: string;
begin
  Result:=GetAttribute('name');
end;

function TFile.FGetHash: string;
begin
  Result:=GetAttribute('hash');
end;

function TFile.FGetRange: TRange;
begin
  Result:=TRange(GetFirstTag(TRange.TagName));
end;

function TFile.FGetSize: Int64;
begin
  Result:=StrToInt64(GetAttribute('size'));
end;

procedure TFile.FSetDate(value: TDateTime);
begin
  SetAttribute('date',DateTimeToJabber(value));
end;

procedure TFile.FSetDescription(value: string);
begin
  SetTag('desc',value);
end;

procedure TFile.FSetFileName(value: string);
begin
  SetAttribute('name',value);
end;

procedure TFile.FSetHash(value: string);
begin
  SetAttribute('hash',value);
end;

procedure TFile.FSetRange(value: TRange);
begin
  RemoveTag(TRange.ClassInfo);
  AddTag(value);
end;

procedure TFile.FSetSize(value: Int64);
begin
  SetAttribute('size',IntToStr(value));
end;

class function TFile.GetConstTagName: string;
begin
  Result:=TagName+'-'+XMLNS_SI_FILE_TRANSFER;
end;

end.
