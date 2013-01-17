unit XmppVCardManager;

interface
uses
  XmppConnection,XmppClientExtension,Xmpp.Iq.VcardIq,Element;
type
  TVCardReceivedHandler=procedure(sender:TObject;iq:tvcardiq) of object;
  TXmppVCardManager=class(TXmppClientExtension)
  private
    _isClientVCardReceived:Boolean;
    _clientVCard:tvcardiq;
    FVCardReceived,FClientVCardReceived:TVCardReceivedHandler;
  public
    constructor Create(_client:TXmppConnection); override;
    procedure RequestVCard(bareJid:string);
    function clientVcard():tvcardiq;
    procedure setClientVCard(iq:tvcardiq);
    procedure requestClientVCard();
    property isClientVCardReceived:Boolean  read _isClientVCardReceived;
    function StreamParserElement(sender:TObject;e:TElement):boolean;override;
    property vCardReceived:TVCardReceivedHandler  read FVCardReceived write FVCardReceived;
    property clientVCardReceived:TVCardReceivedHandler  read FClientVCardReceived write FClientVCardReceived;
  end;

implementation
uses
  XmppClientConnection;

{ TXmppVCardManager }

function TXmppVCardManager.clientVcard: tvcardiq;
begin
  result:=_clientVCard;
end;

constructor TXmppVCardManager.Create(_client: tXmppConnection);
begin
  inherited;
  client:=TXmppClientConnection(_client);
  _isClientVCardReceived:=false;
end;

procedure TXmppVCardManager.requestClientVCard;
begin
  requestVCard('');
end;

procedure TXmppVCardManager.RequestVCard(bareJid: string);
var
  iq:tvcardiq;
begin
  iq:=tvcardiq.create('get',bareJid);
  client.send(iq);
end;

procedure TXmppVCardManager.setClientVCard(iq: tvcardiq);
begin
  _clientVCard := clientVCard;
  _clientVCard.tojid:=nil;
  _clientVCard.fromjid:=nil;
  _clientVCard.IqType:='set';
  client.send(_clientVCard);
end;

function TXmppVCardManager.StreamParserElement(sender: TObject; e: TElement):boolean;
begin
  inherited;
  if e.istagequal(tvcardiq) then
  begin
    if(Tvcardiq(e).fromjid=nil)then
    begin
      _clientVCard:=Tvcardiq(e);
      _isClientVCardReceived := true;
      if Assigned(FClientVCardReceived) then
        FClientVCardReceived(self,Tvcardiq(e));
    end;
    if Assigned(FVCardReceived) then
      FVCardReceived(self,Tvcardiq(e));
    result:=true;
  end
  else
    result:=false;
end;

end.
