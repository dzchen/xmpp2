unit Xmpp.extensions.Chatstate;

interface
uses
  Element,XmppUri;
type
  TChatstate=(
   /// <summary>
        /// No Chatstate at all
        /// </summary>
        None,
        /// <summary>
        /// Active Chatstate
        /// </summary>
        active,
        /// <summary>
        /// Inactive Chatstate
        /// </summary>
        inactive,
        /// <summary>
        /// Composing Chatstate
        /// </summary>
        composing,
        /// <summary>
        /// Gone Chatstate
        /// </summary>
        gone,
        /// <summary>
        /// Paused Chatstate
        /// </summary>
        paused
  );
  TActive=class(Telement)
  const
  TagName='active';
    public
      constructor Create;override;
      class function GetConstTagName():string;override;
  end;

  TComposing=class(Telement)
  const
  TagName='composing';
    public
      constructor Create;override;
      class function GetConstTagName():string;override;
  end;
  TGone=class(Telement)
  const
  TagName='gone';
    public
      constructor Create;override;
      class function GetConstTagName():string;override;
  end;
  TInactive=class(Telement)
  const
  TagName='inactive';
    public
      constructor Create;override;
      class function GetConstTagName():string;override;
  end;
  TPaused=class(Telement)
  const
  TagName='paused';
    public
      constructor Create;override;
      class function GetConstTagName():string;override;
  end;


implementation

{ TActive }

constructor TActive.Create;
begin
  inherited create;
  Name:=TagName;
  Namespace:=XMLNS_CHATSTATES;
end;

class function TActive.GetConstTagName: string;
begin
Result:=TagName+'-'+XMLNS_CHATSTATES;
end;

{ TComposing }

constructor TComposing.Create;
begin
  inherited;
  Name:=TagName;
  Namespace:=XMLNS_CHATSTATES;
end;

class function TComposing.GetConstTagName: string;
begin
Result:=TagName+'-'+XMLNS_CHATSTATES;
end;

{ TGone }

constructor TGone.Create;
begin
  inherited;
  Name:=TagName;
  Namespace:=XMLNS_CHATSTATES;
end;

class function TGone.GetConstTagName: string;
begin
Result:=TagName+'-'+XMLNS_CHATSTATES;
end;

{ TInactive }

constructor TInactive.Create;
begin
  inherited;
  Name:=TagName;
  Namespace:=XMLNS_CHATSTATES;
end;

class function TInactive.GetConstTagName: string;
begin
Result:=TagName+'-'+XMLNS_CHATSTATES;
end;

{ TPaused }

constructor TPaused.Create;
begin
  inherited;
  Name:=TagName;
  Namespace:=XMLNS_CHATSTATES;
end;

class function TPaused.GetConstTagName: string;
begin
Result:=TagName+'-'+XMLNS_CHATSTATES;
end;

end.
