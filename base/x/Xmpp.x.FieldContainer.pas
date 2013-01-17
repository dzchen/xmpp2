unit Xmpp.x.FieldContainer;

interface
uses
Element,XmppUri,Xmpp.x.Field,Generics.Collections,System.Classes;
type
  TFieldContainer=class(TElement)
  public
    function AddField:TField;overload;
    procedure AddField(field:TField);overload;
    function GetField(fieldvar:string):TField;overload;
    function GetFields():TList;overload;
  end;

implementation

{ TFieldContainer }

function TFieldContainer.AddField: TField;
var
  f:TField;
begin
  f:=TField.Create;
  AddTag(f);
  Result:=f;
end;

procedure TFieldContainer.AddField(field: TField);
begin
  AddTag(field);
end;

function TFieldContainer.GetField(fieldvar: string): TField;
var
  el:TList;
  i:integer;
begin
  el:=SelectElements(TField.TagName);
  for i:=0 to el.Count-1 do
  begin
    if TField(el[i]).FieldVar=fieldvar then
    begin
      result:=TField(el[i]);
      Exit;
    end;
  end;

end;

function TFieldContainer.GetFields: TList;
begin
  Result:=SelectElements(TField.TagName);
end;

end.
