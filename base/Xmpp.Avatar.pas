unit Xmpp.Avatar;

interface
uses
  Element,EncdDecd,SysUtils,xmltag;
type
  TAvatar=class(TElement)
  private
    procedure FSetData(value:tbytes);
    function FGetData():tbytes;
    procedure FSetMimeType(value:string);
    function FGetMimeType():string;
  public
    constructor Create(tag:string);override;
    property Data:tbytes  read FGetData write FSetData;
    property MimeType:string read FGetMimeType write FSetMimeType;
  end;

implementation

{ TAvatar }

constructor TAvatar.Create(tag: string);
begin
  inherited Create(tag);
end;

function TAvatar.FGetData: tbytes;
var
  el:txmltag;
begin
  el:=getfirsttag('data');
  if(el<>nil) then
  begin

    Result:=DecodeBase64(el.Data);
  end
  else
    Result:=nil;

end;

function TAvatar.FGetMimeType: string;
begin
  if(getfirsttag('data')<>nil)then
    Result:=GetAttribute('mimetype')
  else
    Result:='';
end;

procedure TAvatar.FSetData(value: tbytes);
begin
  AddBasicTag('data',EncodeBase64(value,length(value)));
end;

procedure TAvatar.FSetMimeType(value: string);
begin
  if(getfirsttag('data')<>nil)then
    SetAttribute('mimetype',value);
end;

end.
