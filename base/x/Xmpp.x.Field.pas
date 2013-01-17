unit Xmpp.x.Field;

interface
uses
  Element,XmppUri,xmpp.x.Option,XMPPConst,jid,xmpp.x.Value,Generics.Collections,System.Classes;
type
  TField=class(TElement)
  const
  TagName='field';
  private
    function FGetFieldVar:string;
    procedure FSetFieldVar(value:string);
    function FGetFieldLabel:string;
    procedure FSetFieldLabel(value:string);
    function FGetFieldType:TFieldType;
    procedure FSetFieldType(value:TFieldType);
    function FGetDescription:string;
    procedure FSetDescription(value:string);
    function FGetRequired:Boolean;
    procedure FSetRequired(value:Boolean);
  public
    constructor Create();overload;override;
    constructor Create(fieldtype:TFieldType);overload;
    constructor Create(val,lab:string;fieldtype:TFieldType);overload;
    property FieldVar:string read FGetFieldVar write FSetFieldVar;
    property FieldLabel:string read FGetFieldLabel write FSetFieldLabel;
    property FieldType:TFieldType read FGetFieldType write FSetFieldType;
    property Description:string read FGetDescription write FSetDescription;
    property IsRequired:Boolean read FGetRequired write FSetRequired;
    function GetValue():string;
    function HasValue(val:string):Boolean;
    procedure SetValue(val:string);
    procedure SetValueBool(val:Boolean);
    function GetValueBool():Boolean;
    function GetValueJid():TJId;
    procedure AddValue(val:string);
    procedure AddValues(vals:array of string);
    procedure SetValues(vals:array of string);
    function GetValues():TArray<string>;
    function AddOption(lab,val:string):TOption;overload;
    function AddOPtion():TOption;overload;
    procedure AddOption(opt:TOption);overload;
    function GetOptions():TList;
    class function GetConstTagName():string;override;
  end;

implementation

{ TField }

procedure TField.AddOption(opt: TOption);
begin
  AddTag(opt);
end;

function TField.AddOption: TOption;
var
  opt:TOption;
begin
  opt:=TOption.Create;
  AddTag(opt);
  Result:=opt;
end;

function TField.AddOption(lab, val: string): TOption;
var
  opt:TOption;
begin
  opt:=TOption.Create(lab,val);
  AddTag(opt);
  Result:=opt;
end;

procedure TField.AddValue(val: string);
begin
  AddTag(TValue.Create(val));
end;

procedure TField.AddValues(vals: array of string);
var
  i:Integer;
begin
  for i := Low(vals) to high(vals) do
    AddValue(vals[i]);
end;

constructor TField.Create(val, lab: string; fieldtype: TFieldType);
begin
  Self.Create;
  Self.FieldType:=fieldtype;
  Self.FieldLabel:=lab;
  Self.FieldVar:=val;
end;

constructor TField.Create(fieldtype: TFieldType);
begin
  Self.Create;
  Self.FieldType:=fieldtype;
end;

constructor TField.Create;
begin
  inherited Create;
  Name:='field';
  Namespace:=XMLNS_X_DATA;
end;

function TField.FGetDescription: string;
begin
  Result:=GetTag('desc');
end;

function TField.FGetFieldLabel: string;
begin
  Result:=GetAttribute('label');
end;

function TField.FGetFieldType: TFieldType;
begin
  if (GetAttribute('type')='boolean') then
    result:=TFieldType.FTBoolean
	else if (GetAttribute('type')='fixed') then
						result:=TFieldType.FTFixed
  else if (GetAttribute('type')='hidden') then
						result:=TFieldType.FTHidden
  else if (GetAttribute('type')='jid-multi') then
						result:=TFieldType.FTJid_Multi
  else if (GetAttribute('type')='jid-single') then
						result:=TFieldType.FTJid_Single
  else if (GetAttribute('type')='list-multi') then
						result:=TFieldType.FTList_Multi
  else if (GetAttribute('type')='list-single') then
						result:=TFieldType.FTList_Single
  else if (GetAttribute('type')='text-multi') then
						result:=TFieldType.FTText_Multi
  else if (GetAttribute('type')='text-private') then
						result:=TFieldType.FTText_Private
  else if (GetAttribute('type')='text-single') then
    result:=TFieldType.FTText_Single
  else
    result:=TFieldType.FTUnknown;
end;

function TField.FGetFieldVar: string;
begin
  Result:=GetAttribute('var');
end;

function TField.FGetRequired: Boolean;
begin
  Result:=HasTag('required');
end;

procedure TField.FSetDescription(value: string);
begin
  SetTag('desc',value);
end;

procedure TField.FSetFieldLabel(value: string);
begin
  SetAttribute('label',value);
end;

procedure TField.FSetFieldType(value: TFieldType);
begin

  case (value)  of

					TFieldType.FTBoolean:
						SetAttribute('type', 'boolean');

					TFieldType.FTFixed:
						SetAttribute('type', 'fixed');

					TFieldType.FTHidden:
						SetAttribute('type', 'hidden');

					TFieldType.FTJid_Multi:
						SetAttribute('type', 'jid-multi');

					TFieldType.FTJid_Single:
						SetAttribute('type', 'jid-single');

					TFieldType.FTList_Multi:
						SetAttribute('type', 'list-multi');

					TFieldType.FTList_Single:
						SetAttribute('type', 'list-single');

					TFieldType.FTText_Multi:
						SetAttribute('type', 'text-multi');

					TFieldType.FTText_Private:
						SetAttribute('type', 'text-private');

					TFieldType.FTText_Single:
						SetAttribute('type', 'text-single');
					else
						RemoveAttribute('type');
  end;
end;

procedure TField.FSetFieldVar(value: string);
begin
  SetAttribute('var',value);
end;

procedure TField.FSetRequired(value: Boolean);
begin
  if value then
    SetTag('required','')
  else
    RemoveTag('required');
end;

class function TField.GetConstTagName: string;
begin
Result:=TagName+'-'+XMLNS_X_DATA;
end;

function TField.GetOptions: TList;

begin
  Result:=SelectElements(TOption.TagName);
end;

function TField.GetValue: string;
begin
  Result:=GetTag(TValue.TagName);
end;

function TField.GetValueBool: Boolean;
var
  s:string;
begin
  s:=GetValue;
  if (s='') or (s='0') then
    Result:=false
  else
    Result:=true;
end;

function TField.GetValueJid: TJId;
begin
  Result:=TJID.Create(GetValue);
end;

function TField.GetValues: TArray<string>;
var el:TList;
  e:TElement;
  sl:TArray<string>;
  i:integer;
begin
  el:=SelectElements(TValue.TagName);
  setlength(sl,el.Count);

  for i:=0 to el.Count-1 do
  begin
    sl[i]:=e.data;
  end;
  el.Free;
  el:=nil;
  Result:=sl;
end;

function TField.HasValue(val: string): Boolean;
var s:string;
  el:TArray<string>;
begin
  el:=GetValues;
  for s in el do
    if s=val then
    begin
      Result:=true;
      Exit;
    end;
  Result:=false;
end;

procedure TField.SetValue(val: string);
begin
  SetTag(TValue.TagName,val);
end;

procedure TField.SetValueBool(val: Boolean);
begin
  if val then
    SetValue('1')
  else
    SetValue('0');
end;

procedure TField.SetValues(vals: array of string);
var
  el:TList;
  i:Integer;
begin
  el:=SelectElements(TValue.TagName);
  for i := 0 to el.Count do
    RemoveTag(el[i]);
  el.Free;
  el:=nil;
  AddValues(vals);
end;

end.
