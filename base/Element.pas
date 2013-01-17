unit Element;

interface
uses
 xmltag,Classes,jid,EncdDecd,System.SysUtils,StrUtils;
type
  TClassElement=class of telement;
  TElement=class(TXMLTag)
  private
    function FGetTextBase64: string;
    procedure FSetTextBase64(value:string);

    procedure _SelectElements(se: Telement; tagname: string; const es: TList;
      traversechildren: Boolean);
    procedure FSetValue(value:string);

  public
    constructor Create; overload; override;
    constructor Create(tagname,tagtext,ns:string);overload;virtual;
    function HasTag(tag:string):Boolean;overload;
    function HasAttribute(tag:string):Boolean;
    function GetTag(tag:string):string;overload;
    function GetTag(tag:string;attname:string;attvalue:string):TXMLTag;overload;

      function GetTagBase64(tagname:string):string;
      function GetTagBool(tagname:string):Boolean;

      function GetTagInt(tagname:string):integer;
      function GetTagJid(tagname:string):TJid;

    function SelectElements(tagname:string):TList;overload;
    function SelectElements(tagname:string;traverseChildren:Boolean):TList;overload;
    procedure ReplaceNode(e:Telement);overload;
    procedure SetTag(name,value:string);overload;
    procedure SetTag(name,value,ns:string);overload;
    property Value:string read Data write FSetValue;
    property TextBase64:string read FGetTextBase64 write FSetTextBase64;
    class function GetConstTagName():string;virtual;abstract;
    function IsTagEqual(tgname: string): Boolean;overload;
    function IsTagEqual(e: TClassElement): Boolean;overload;
  end;
implementation

{ TElement }

constructor TElement.Create(tagname, tagtext, ns: string);
begin
  inherited Create(tagname,tagtext);
  SetNameSpace(ns);
end;

procedure TElement.FSetTextBase64(value: string);
var
  b:tbytes;
begin
  b:=BytesOf(UTF8Encode(value));
  Self.Value:=(EncodeBase64(b,Length(b)));
end;

procedure TElement.FSetValue(value: string);
begin
  ClearCData;
  AddCData(value);
end;

function TElement.FGetTextBase64: string;
var
  b:Tbytes;
begin
  b:=DecodeBase64(Data);
  Result:=StringOf(b);
end;

function TElement.GetTag(tag: string): string;
begin
  Result:=GetBasicText(tag);
end;

constructor TElement.Create;
begin
  inherited;

end;

function TElement.GetTag(tag, attname, attvalue: string): TXMLTag;
var
  sname: string;
  i: integer;
  n: TXMLNode;
begin
  Result := nil;
  if tag=name then
  begin
    if HasAttribute(attname) then
      if GetAttribute(attname)=attvalue then
        Result:=Self;
  end
  else
  begin
    sname := Trim(tag);
    assert(ChildTags <> nil);
    for i := 0 to ChildTags.Count - 1 do
    begin
      n := TXMLNode(ChildTags[i]);
      if ((n.IsTag) and (CompareStr(sname, n.name)=0)) then
      begin
        Result := GetTag(tag, attname, attvalue);
        exit;
      end;
    end;
  end;
end;

function TElement.GetTagBase64(tagname: string): string;
begin
  Result:=EncdDecd.DecodeString(GetTag(tagname));
end;

function TElement.GetTagBool(tagname: string): Boolean;
var
  s:string;
begin
    s:= GetBasicText(tagname);
    if (s='false') or (s='0') then
      Result:=false
    else if (s='true') or (s='1') then
      Result:=True
    else
      Result:=false;
end;

function TElement.GetTagInt(tagname: string): integer;
var
  s:string;
begin
  s:=GetBasicText(tagname);
  if s<>'' then
  Result:=StrToInt(s)
  else
  Result:=0;
end;

function TElement.GetTagJid(tagname: string): TJid;
var
  s:string;
begin
  s:=GetTag(tagname);
  if(s<>'')then
    Result:=TJID.Create(s)
  else
    Result:=nil;
end;

function TElement.HasAttribute(tag: string): Boolean;
begin
  if Attributes.Node(tag)=nil then
  Result:=False
  else
  Result:=true;
end;

function TElement.SelectElements(tagname: string): TList;
var
  es:TList;
begin
  es:=tlist.Create;
  _SelectElements(Self,tagname,es,false);
  Result:=es;
end;

function TElement.HasTag(tag: string): Boolean;
begin
  result:=Self.TagExists(tag);
end;

procedure TElement.ReplaceNode(e: Telement);
begin
  if HasTag(e.Name) then
    RemoveTag(e.Name);
  AddTag(e);
end;

function TElement.SelectElements(tagname: string;
  traverseChildren: Boolean): TList;
var
  es:TList;
begin
  es:=tlist.Create;
  _SelectElements(Self,tagname,es,traverseChildren);
  Result:=es;
end;
procedure TElement.SetTag(name, value, ns: string);
var
  el:TElement;
begin
  if TagExists(name) then
  begin
    el:=TElement(GetFirstTag(name));
    el.value:=value;
    el.SetNameSpace(ns);
  end
  else
    AddTag(TElement.Create(name,value,ns));
end;

procedure TElement.SetTag(name, value: string);
begin
  AddBasicTag(name,value);
end;

procedure TElement._SelectElements(se: Telement; tagname: string; const es: TList;
  traversechildren: Boolean);
var
  i:Integer;
  ch:TElement;
begin
  if se.ChildTags.Count>0 then
  begin
    for i := 0 to se.ChildTags.Count-1 do
    begin
      ch:=TElement(se.ChildTags[i]);
      if ch.NodeType=xml_Tag then
      begin
        if ch.Name=tagname then
          es.Add(ch);
        if traversechildren then
          _selectelements(ch,tagname,es,True);
      end;
    end;
  end;
end;

function TElement.IsTagEqual(e: TClassElement): Boolean;
var
  nm,ns:string;
begin
  Result:=false;
  if(Self=nil)then
  begin
  Result:=false;
  end
  else
  begin
  nm:=e.GetConstTagName;
  if Pos('-',nm)>0 then
  begin
    ns:=MidStr(nm,Pos('-',nm)+1,Length(nm));
    nm:=MidStr(nm,1,Pos('-',nm)-1);
  end;
  if IsTagEqual(nm) and (ns=getnamespace) then
    Result:=true;

  end;
end;

function TElement.IsTagEqual(tgname: string): Boolean;
var
 n:Integer;
begin
  Result:=false;
  n:=Pos(':',name);
  if(n>1) then
  begin
    if(LowerCase(midstr(name,n+1,Length(name)))=LowerCase(tgname))then
      Result:=true;
  end
  else
  begin
    if(name=tgname)then
      Result:=true;
  end;
end;

end.
