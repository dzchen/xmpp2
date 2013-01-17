unit Xmpp.Iq.SessionIq;

interface
uses
  xmpp.client.IQ,xmltag,Jid,Element,xmppuri;
type
  TSession=class(TElement)
  const
    TagName='session';
  public
    constructor Create();override;
    class function GetConstTagName():string;override;
  end;
  TSessionIq=class(TIQ)
  private
    _session:TSession;
  public
    constructor Create();overload;override;
    constructor Create(iqtype:string);overload;
    constructor Create(iqtype:string;tojid:TJID);overload;
  end;
implementation

{ TSession }

constructor TSession.Create();
begin
  inherited Create;
  Name:='session';
  Namespace:=XMLNS_SESSION;
end;

class function TSession.GetConstTagName: string;
begin
Result:=TagName+'-'+XMLNS_SESSION;
end;

{ TSessionIq }

constructor TSessionIq.Create();
begin
  inherited Create();
  GenerateId;
  _session:=TSession.Create();
  FSetQuery(_session);
end;

constructor TSessionIq.Create(iqtype: string);
begin
  self.Create();
  self.IqType:=iqtype;
end;

constructor TSessionIq.Create(iqtype: string; tojid: TJID);
begin
  self.Create(iqtype);
  self.tojid:=tojid;
end;

end.
