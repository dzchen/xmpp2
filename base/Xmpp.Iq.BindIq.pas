unit Xmpp.Iq.BindIq;

interface
uses
  Element,XmppUri,jid,Xmpp.client.iq;
type
  TBind=class(TElement)
  const
    TagName:string='bind';
  private
    procedure FSetResource(value:string);
    function FGetResource():string;
    procedure FSetJId(value:TJID);
    function FGetJid():TJID;
  public
    constructor Create();override;
    constructor CreateResource(resouce:string);
    constructor CreateJid(jid:Tjid);
    property Resource:string read FGetResource write FSetResource;
    property Jid:TJID read FGetJid write FSetJId;
    class function GetConstTagName():string;override;
  end;
  TBindIq=class(TIQ)
  private
    _bind:Tbind;
  public
    constructor Create();overload;override;
    constructor Create(iqtype:string);overload;
    constructor Create(iqtype:string;tojid:TJID);overload;
    constructor Create(iqtype:string;tojid:TJID;resource:string);overload;
    property Query:TBind read _bind;
  end;

implementation

{ TBind }

constructor TBind.Create();
begin
  inherited Create;
  Name:='bind';
  Namespace:=XMLNS_BIND;
end;

constructor TBind.CreateJid(jid: Tjid);
begin
  self.Create();
  self.Jid:=jid;
end;

constructor TBind.CreateResource(resouce: string);
begin
  self.Create();
  self.Resource:=resource;
end;

function TBind.FGetJid: TJID;
begin
  Result:=TJID.Create(getbasictext('jid'));
end;

function TBind.FGetResource: string;
begin
  Result:=getbasictext('resource');
end;

procedure TBind.FSetJId(value: TJID);
begin
  addbasictag('jid',value.ToString);
end;

procedure TBind.FSetResource(value: string);
begin
  addbasictag('resource',value);
end;
class function TBind.GetConstTagName():string;
begin
  Result:=TagName+'-'+XMLNS_BIND;
end;

{ TBindIq }

constructor TBindIq.Create(iqtype: string);
begin
  Self.Create();
  self.IqType:=iqtype;
end;

constructor TBindIq.Create();
begin
  inherited Create();
  GenerateId;
  _bind:=TBind.Create();
  FSetQuery(_bind);
end;

constructor TBindIq.Create(iqtype: string; tojid: TJID;
  resource: string);
begin
  Self.Create(iqtype,tojid);
  _bind.Resource:=resource;
end;

constructor TBindIq.Create(iqtype: string; tojid: TJID);
begin
  Self.Create(iqtype);
  Self.ToJid:=tojid;
end;

end.
