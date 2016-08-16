//***************************************************************************
//
//       名称：DDuilibComponent.pas
//       作者：ying32
//       QQ  ：1444386932
//       E-mail：1444386932@qq.com
//       做成一个组件用来与VCL相结合
//       版权所有 (C) 2015-2016 ying32 All Rights Reserved
//       半夜又被蚊子咬醒了，又被外面的车子吵着，干脆起来写代码了
//       代码完成时间差不多快早上6点了，唉。
//
//***************************************************************************
unit DDuilibComponent;

{$I DDuilib.inc}

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Forms,
  Duilib,
  DuiConst,
  DuiWindowImplBase;

type

  TDDuiApp = class(TComponent)
  private
    FOld: TMessageEvent;
    FOnMessage: TMessageEvent;
    FZipFileName: string;
    FResourcePath: string;
    FResourceDll: string;
    ResourceDllHinst: HINST;
    procedure NewMessage(var Msg: TMsg; var Handled: Boolean);
    procedure SetZipFileName(const Value: string);
    procedure SetResourcePath(const Value: string);
    procedure SetResourceDll(const Value: string);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property ZipFileName: string read FZipFileName write SetZipFileName;
    property ResourcePath: string read FResourcePath write SetResourcePath;
    property ResourceDll: string read FResourceDll write SetResourceDll;
    property OnMessage: TMessageEvent read FOnMessage write FOnMessage;
  end;

  TSkinKind = (skFile = 1, skZip, skResource, skZipResource);

  TDuiNotifyEvent = procedure(Sender: TObject; var Msg: TNotifyUI) of object;
  TDuiMessageEvent = procedure(Sender: TObject; var Msg: TMessage; var bHandled: BOOL) of object;
  TDuiFinalMessageEvent = procedure(Sender: TObject; hWd: HWND) of object;
  TDuiCreateControlEvent = procedure(Sender: TObject; pstrStr: string; var Result: CControlUI) of object;
  TDuiGetItemTextEvent = procedure(Sender: TObject; pControl: CControlUI; iIndex, iSubItem: Integer; var Result: string) of object;
  TDuiResponseDefaultKeyEvent = procedure(Sender: TObject; wParam: WPARAM; var AResult: LRESULT) of object;

  TDuiComponent = class(TDuiWindowImplBase)
  private
    FOnInitWindow: TNotifyEvent;
    FOnHandleCustomMessage: TDuiMessageEvent;
    FOnNotify: TDuiNotifyEvent;
    FOnFinalMessage: TDuiFinalMessageEvent;
    FOnMessageHandler: TDuiMessageEvent;
    FOnCreateControl: TDuiCreateControlEvent;
    FOnResponseDefaultKey: TDuiResponseDefaultKeyEvent;
    FOnHandleMessage: TDuiMessageEvent;
    FOnClick: TDuiNotifyEvent;
  protected
    procedure DoInitWindow; override;
    procedure DoNotify(var Msg: TNotifyUI); override;
    procedure DoClick(var Msg: TNotifyUI); override;
    procedure DoHandleMessage(var Msg: TMessage; var bHandled: BOOL); override;
    procedure DoMessageHandler(var Msg: TMessage; var bHandled: BOOL); override;
    procedure DoFinalMessage(hWd: HWND); override;
    procedure DoHandleCustomMessage(var Msg: TMessage; var bHandled: BOOL); override;
    function DoCreateControl(pstrStr: string): CControlUI; override;
    procedure DoResponseDefaultKeyEvent(wParam: WPARAM; var AResult: LRESULT); override;
  public
    property OnInitWindow: TNotifyEvent read FOnInitWindow write FOnInitWindow;
    property OnClick: TDuiNotifyEvent read FOnClick write FOnClick;
    property OnNotify: TDuiNotifyEvent read FOnNotify write FOnNotify;
    property OnHandleMessage: TDuiMessageEvent read FOnHandleMessage write FOnHandleMessage;
    property OnMessageHandler: TDuiMessageEvent read FOnMessageHandler write FOnMessageHandler;
    property OnFinalMessage: TDuiFinalMessageEvent read FOnFinalMessage write FOnFinalMessage;
    property OnHandleCustomMessage: TDuiMessageEvent read FOnHandleCustomMessage write FOnHandleCustomMessage;
    property OnCreateControl: TDuiCreateControlEvent read FOnCreateControl write FOnCreateControl;
    property OnResponseDefaultKey: TDuiResponseDefaultKeyEvent read FOnResponseDefaultKey write FOnResponseDefaultKey;
  end;

  TDDuiForm = class(TComponent)
  private
    FForm: TCustomForm;
    FSkinFolder: string;
    FSkinXml: string;
    FSkinResName: string;
    FSkinKind: TSkinKind;
    FDuiComponent: TDuiComponent;
    FSkinZip: string;
    FOldWndProc: TWndMethod;
    FIsNcDown: Boolean;
    FOnHandleCustomMessage: TDuiMessageEvent;
    FOnGetItemText: TDuiGetItemTextEvent;
    FOnNotify: TDuiNotifyEvent;
    FOnFinalMessage: TDuiFinalMessageEvent;
    FOnMessageHandler: TDuiMessageEvent;
    FOnCreateControl: TDuiCreateControlEvent;
    FOnInitWindow: TNotifyEvent;
    FOnResponseDefaultKey: TDuiResponseDefaultKeyEvent;
    FOnHandleMessage: TDuiMessageEvent;
    FOnClick: TDuiNotifyEvent;
    procedure NewWndProc(var Msg: TMessage);
  protected
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure InitDuiComponent; // 先这样，暂时没有其它想法，在OnCreate事件中已经创建了，消息已经过去了，则没有处理到
     // 导出
    property DUI: TDuiComponent read FDuiComponent write FDuiComponent;
  published
    property SkinFolder: string read FSkinFolder write FSkinFolder;
    property SkinXml: string read FSkinXml write FSkinXml;
    property SkinZip: string read FSkinZip write FSkinZip;
    // 暂不可写，只能使用默认的 DefaultSkin;
    property SkinResName: string read FSkinResName write FSkinResName;
    property SkinKind: TSkinKind read FSkinKind write FSkinKind;

    property OnInitWindow: TNotifyEvent read FOnInitWindow write FOnInitWindow;
    property OnClick: TDuiNotifyEvent read FOnClick write FOnClick;
    property OnNotify: TDuiNotifyEvent read FOnNotify write FOnNotify;
    property OnHandleMessage: TDuiMessageEvent read FOnHandleMessage write FOnHandleMessage;
    property OnMessageHandler: TDuiMessageEvent read FOnMessageHandler write FOnMessageHandler;
    property OnFinalMessage: TDuiFinalMessageEvent read FOnFinalMessage write FOnFinalMessage;
    property OnHandleCustomMessage: TDuiMessageEvent read FOnHandleCustomMessage write FOnHandleCustomMessage;
    property OnCreateControl: TDuiCreateControlEvent read FOnCreateControl write FOnCreateControl;
    property OnGetItemText: TDuiGetItemTextEvent read FOnGetItemText write FOnGetItemText;
    property OnResponseDefaultKey: TDuiResponseDefaultKeyEvent read FOnResponseDefaultKey write FOnResponseDefaultKey;
  end;

  procedure Register;
implementation

procedure Register;
begin
  RegisterComponents('DDuilib', [TDDuiApp, TDDuiForm]);
end;

var
  AppObjectExists: Boolean;


{ TDDuiApp }

constructor TDDuiApp.Create(AOwner: TComponent);
begin
  if AppObjectExists then
    raise Exception.Create('DDuilib App Object已经存在！');
  inherited Create(AOwner);
  if not (csDesigning in ComponentState) then
  begin
    if Assigned(Application) then
    begin
      FOld := Application.OnMessage;
      Application.OnMessage := NewMessage;
    end;
    CPaintManagerUI.SetInstance(HInstance);
  end;
  AppObjectExists := True;
end;

destructor TDDuiApp.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if Assigned(FOld) then
      Application.OnMessage := FOld;
    CPaintManagerUI.Term;
    if ResourceDllHinst <> 0 then
      FreeLibrary(ResourceDllHinst);
  end;
  inherited;
end;

procedure TDDuiApp.NewMessage(var Msg: TMsg; var Handled: Boolean);
begin
  if CPaintManagerUI.TranslateMessage(@Msg) then
  begin
    Handled := True;  // 未测
  end;
  if Assigned(FOnMessage) then
    FOnMessage(Msg, Handled);
  if Assigned(FOld) then
    FOld(Msg, Handled);
end;

procedure TDDuiApp.SetResourceDll(const Value: string);
begin
  if FResourceDll <> Value then
  begin
    FResourceDll := Value;
    if not(csDesigning in ComponentState) then
    begin
      if GetModuleHandle(PChar(Value)) <> ResourceDllHinst then
      begin
        if ResourceDllHinst <> 0 then
          FreeLibrary(ResourceDllHinst)
      end;
      ResourceDllHinst := SafeLoadLibrary(FResourceDll);
      CPaintManagerUI.SetResourceDll(ResourceDllHinst);
    end;
  end;
end;

procedure TDDuiApp.SetResourcePath(const Value: string);
begin
  if FResourcePath <> Value then
  begin
    FResourcePath := Value;
    if not (csDesigning in ComponentState) then
      CPaintManagerUI.SetResourcePath(FResourcePath);
  end;
end;

procedure TDDuiApp.SetZipFileName(const Value: string);
begin
  if FZipFileName <> Value then
  begin
    FZipFileName := Value;
    if not (csDesigning in ComponentState) then
    begin
      CPaintManagerUI.Term; // 不知道需要否？
      CPaintManagerUI.SetResourceZip(FZipFileName);
    end;
  end;
end;

{ TDDuiForm }

constructor TDDuiForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if not(AOwner is TCustomForm) then
    raise Exception.Create('DDuiForm必须创建在TCustomForm之上。');
  FForm := AOwner as TCustomForm;
  FSkinResName := 'DefaultSkin';
  FSkinKind := skFile;
  if not(csDesigning in ComponentState) then
  begin
    FOldWndProc := FForm.WindowProc;
    FForm.WindowProc := NewWndProc;
  end;
end;

destructor TDDuiForm.Destroy;
begin
  if not(csDesigning in ComponentState) then
  begin
    if Assigned(FOldWndProc) then
      FForm.WindowProc := FOldWndProc;
  end;
  inherited;
end;

procedure TDDuiForm.InitDuiComponent;
begin
  if FDuiComponent = nil then
  begin
    FDuiComponent := TDuiComponent.Create(FSkinXml, FSkinFolder, FSkinZip, FSkinResName, TResourceType(FSkinKind));
    FDuiComponent.OnHandleCustomMessage := FOnHandleCustomMessage;
    FDuiComponent.OnNotify := FOnNotify;
    FDuiComponent.OnFinalMessage := FOnFinalMessage;
    FDuiComponent.OnMessageHandler := FOnMessageHandler;
    FDuiComponent.OnCreateControl := FOnCreateControl;
    FDuiComponent.OnInitWindow := FOnInitWindow;
    FDuiComponent.OnResponseDefaultKey := FOnResponseDefaultKey;
    FDuiComponent.OnHandleMessage := FOnHandleMessage;
    FDuiComponent.OnClick := FOnClick;
    {$IFDEF SupportGeneric}FDuiComponent.this{$ELSE}CDelphi_WindowImplBase(FDuiComponent.this){$ENDIF}.CreateDelphiWindow(FForm.Handle);
  end;
end;

procedure TDDuiForm.Loaded;
begin
  inherited;
  // 设计的貌似就可以这样，动态创建要调用下 InitDuiComponent
  if not(csDesigning in ComponentState) then
    InitDuiComponent;
end;


procedure TDDuiForm.NewWndProc(var Msg: TMessage);
var
  LRes: LRESULT;
begin
  case Msg.Msg of
//    WM_NCCREATE :
//      begin
//        MessageBox(0, 'WM_NCCREATE', nil, 0);
//      end;
//    WM_CREATE :
//      begin
//        MessageBox(0, 'WM_CREATE', nil, 0);
//      end;
    WM_NCDESTROY :
      begin
        if FDuiComponent <> nil then
          FDuiComponent.DoFinalMessage(FForm.Handle);
      end;
    WM_DESTROY:
      begin
        if Assigned(FDuiComponent) then
          FreeAndNil(FDuiComponent);
      end;
  end;
  if FDuiComponent <> nil then
  begin
    LRes := {$IFDEF SupportGeneric}FDuiComponent.This{$ELSE}CDelphi_WindowImplBase(FDuiComponent.This){$ENDIF}.DelphiMessage(Msg.Msg, Msg.WParam, Msg.LParam);
    if LRes <> 0 then
    begin
      Msg.Result := LRes;
      Exit; // 这里不知道要不要也作处理
    end;
    if FDuiComponent.PaintManagerUI.MessageHandler(Msg.Msg, Msg.WParam, Msg.LParam, LRes) then
    begin
      Msg.Result := LRes;
      // 前面处理了不能作退出处理，不然Delphi收不到相关消息
      if Msg.Msg = WM_SETCURSOR then
        Exit;
    end;
    // 是否需要?
    if (Msg.Msg = WM_PAINT) and (LRes <> 0) then
      Exit;
  end;
  // 解决调整边框时无法收WM_NCLBUTTONUP消息
  if Msg.Msg = WM_NCLBUTTONDOWN then
    FIsNcDown := True
  else if Msg.Msg = WM_NCLBUTTONUP then
  begin
    FIsNcDown := False;
    ReleaseCapture;
  end;

  if Msg.Msg = WM_EXITSIZEMOVE then
  begin
    if FIsNcDown then
    begin
      PostMessage(FForm.Handle, WM_NCLBUTTONUP, HTCAPTION, 0);
      //Exit;
    end;
  end;
{
  WM_NCCREATE         = $0081;
  WM_NCDESTROY        = $0082;
  WM_NCCALCSIZE       = $0083;
  WM_NCHITTEST        = $0084;
  WM_NCPAINT          = $0085;
  WM_NCACTIVATE       = $0086;
  WM_GETDLGCODE       = $0087;
  WM_NCMOUSEMOVE      = $00A0;
  WM_NCLBUTTONDOWN    = $00A1;
  WM_NCLBUTTONUP      = $00A2;
  WM_NCLBUTTONDBLCLK  = $00A3;
  WM_NCRBUTTONDOWN    = $00A4;
  WM_NCRBUTTONUP      = $00A5;
  WM_NCRBUTTONDBLCLK  = $00A6;
  WM_NCMBUTTONDOWN    = $00A7;
  WM_NCMBUTTONUP      = $00A8;
  WM_NCMBUTTONDBLCLK  = $00A9;
  WM_NCXBUTTONDOWN    = $00AB;
  WM_NCXBUTTONUP      = $00AC;
  WM_NCXBUTTONDBLCLK  = $00AD;
}
  // 非m_bLayered时要自行拦截NC相关的消息，不能让Delphi处理
  case Msg.Msg of
//    WM_NCCREATE,
//    WM_NCDESTROY,
    WM_NCCALCSIZE,
    WM_NCHITTEST,
    WM_NCPAINT,
    WM_NCACTIVATE:
//    WM_GETDLGCODE,
//    WM_NCMOUSEMOVE,
//    WM_NCLBUTTONDOWN,
//    WM_NCLBUTTONUP,
//    WM_NCLBUTTONDBLCLK,
//    WM_NCRBUTTONDOWN,
//    WM_NCRBUTTONUP,
//    WM_NCRBUTTONDBLCLK,
//    WM_NCMBUTTONDOWN,
//    WM_NCMBUTTONUP,
//    WM_NCMBUTTONDBLCLK,
//    WM_NCXBUTTONDOWN,
//    WM_NCXBUTTONUP,
//    WM_NCXBUTTONDBLCLK:
     ;
  else
    if Assigned(FOldWndProc) then
      FOldWndProc(Msg);
  end;
end;

{ TDuiComponent }

procedure TDuiComponent.DoClick(var Msg: TNotifyUI);
begin
  if Assigned(FOnClick) then
    FOnClick(Self, Msg);
end;

function TDuiComponent.DoCreateControl(pstrStr: string): CControlUI;
begin
  Result := nil;
  if Assigned(FOnCreateControl) then
    FOnCreateControl(Self, pstrStr, Result);
end;

procedure TDuiComponent.DoFinalMessage(hWd: HWND);
begin
  if Assigned(FOnFinalMessage) then
    FOnFinalMessage(Self, hWd);
end;

procedure TDuiComponent.DoHandleCustomMessage(var Msg: TMessage;
  var bHandled: BOOL);
begin
  if Assigned(FOnHandleCustomMessage) then
    FOnHandleCustomMessage(Self, Msg, bHandled);
end;

procedure TDuiComponent.DoHandleMessage(var Msg: TMessage; var bHandled: BOOL);
begin
  if Assigned(FOnHandleMessage) then
    FOnHandleMessage(Self, Msg, bHandled);
end;

procedure TDuiComponent.DoInitWindow;
begin
  if Assigned(FOnInitWindow) then
    FOnInitWindow(Self);
end;

procedure TDuiComponent.DoMessageHandler(var Msg: TMessage; var bHandled: BOOL);
begin
  if Assigned(FOnMessageHandler) then
    FOnMessageHandler(Self, Msg, bHandled);
end;

procedure TDuiComponent.DoNotify(var Msg: TNotifyUI);
begin
  if Assigned(FOnNotify) then
    FOnNotify(Self, Msg);
end;

procedure TDuiComponent.DoResponseDefaultKeyEvent(wParam: WPARAM;
  var AResult: LRESULT);
begin
  if Assigned(FOnResponseDefaultKey) then
    FOnResponseDefaultKey(Self, wParam, AResult);
end;

end.
