unit xmpp.iq.Roster;

interface
uses
  Element,XmppUri,xmpp.iq.RosterItem,Generics.Collections,System.Classes;
type
  TRoster=class(TElement)
  const
  TagName='query';
  NameSpace=XMLNS_IQ_ROSTER;
  public
    constructor Create;override;
    function GetRoster():TList;
    procedure AddRosterItem(r:TRosterItem);
    class function GetConstTagName():string;override;
  end;

implementation

{ TRoster }

procedure TRoster.AddRosterItem(r: TRosterItem);
begin
  AddTag(r);
end;

constructor TRoster.Create;
begin
  inherited create;
  Name:='query';
  SetNamespace(XMLNS_IQ_ROSTER);
end;

class function TRoster.GetConstTagName: string;
begin
Result:=TagName+'-'+XMLNS_IQ_ROSTER;
end;

function TRoster.GetRoster: TList;
begin
  Result:=SelectElements(TRosterItem.Tagname);
end;

end.
