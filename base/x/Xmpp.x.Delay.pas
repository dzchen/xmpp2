unit Xmpp.x.Delay;

interface
uses
  Element,Jid,XmppUri,time;
type
  TDelay=class(TElement)
  const
  TagName='x';
  private
    function FGetFromJid:TJID;
    procedure FSetFromJid(value:TJID);
    function FGetStamp:TDateTime;
    procedure FSetStamp(value:TDateTime);
  public
    constructor Create();override;
    property FromJid:TJID read FGetFromJid write FSetFromJid;
    property Stamp:TDateTime read FGetStamp write FSetStamp;
    class function GetConstTagName():string;override;
  end;


implementation

{ TDelay }

constructor TDelay.Create();
begin
  inherited Create();
  Name:='x';
  Namespace:=XMLNS_X_DELAY;
end;

function TDelay.FGetFromJid: TJID;
begin
  if HasAttribute('from') then
    Result:=tjid.Create(GetAttribute('from'))
  else
    Result:=nil;
end;

function TDelay.FGetStamp: TDateTime;
begin
  time.JabberToDateTime(GetAttribute('stamp'));
end;

procedure TDelay.FSetFromJid(value: TJID);
begin
  SetAttribute('from',value.ToString);
end;

procedure TDelay.FSetStamp(value: TDateTime);
begin
  SetAttribute('stamp',time.DateTimeToJabber(value));
end;

class function TDelay.GetConstTagName: string;
begin
Result:=TagName+'-'+XMLNS_X_DELAY;
end;

end.
