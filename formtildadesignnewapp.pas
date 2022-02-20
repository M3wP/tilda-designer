unit FormTildaDesignNewApp;

{$mode ObjFPC}{$H+}

interface

uses
	Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ValEdit, ExtCtrls,
	StdCtrls, Buttons;

type

	{ TTildaDesignNewAppForm }

	TTildaDesignNewAppForm = class(TForm)
		BitBtn1: TBitBtn;
		BitBtn2: TBitBtn;
		Label1: TLabel;
		Label2: TLabel;
		Panel1: TPanel;
		Panel2: TPanel;
		ValueListEditor1: TValueListEditor;
		procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
		procedure FormShow(Sender: TObject);
	private

	public

	end;

var
	TildaDesignNewAppForm: TTildaDesignNewAppForm;

implementation

{$R *.lfm}

uses
	TildaDesignTypes, TildaDesignUtils;

{ TTildaDesignNewAppForm }

procedure TTildaDesignNewAppForm.FormCloseQuery(Sender: TObject;
		var CanClose: Boolean);
	var
	mi,
	ui,
	li,
	vi: string;
	w,
	h: Integer;

	m: TTildaModule;
	u: TTildaUInterface;
	l: TTildaLayer;
	v: TTildaView;

	begin
	if  ModalResult = mrOK then
		begin
		mi:= ValueListEditor1.Values['Module Ident'];
		ui:= ValueListEditor1.Values['UInterface Ident'];
		li:= ValueListEditor1.Values['Layer Ident'];
		vi:= ValueListEditor1.Values['View Ident'];

		if  not TryStrToInt(ValueListEditor1.Values['Screen Width'], w) then
			w:= 0;
		if  not TryStrToInt(ValueListEditor1.Values['Screen Height'], h) then
			h:= 0;

		if  (not IsValidIdent(mi))
		or  (not IsValidIdent(ui))
		or  (not IsValidIdent(li))
		or  (not IsValidIdent(vi))
		or  (not (w in [40, 80]))
		or  (not (h in [25, 50])) then
			CanClose:= False
		else
			begin
			m:= TTildaModule.Create(mi, nil);
			u:= TTildaUInterface.Create(ui, m);
			l:= TTildaLayer.Create(li, u);
			l.width:= w;

			v:= TTildaView.Create(vi, u);
			v.width:= w;
			v.height:= h;

			m.units.Add(u);
			v.layers.Add(l);
			u.views.Add(v);

			abstracts.Add(m);
			abstracts.Add(u);
			abstracts.Add(l);
			abstracts.Add(v);

			CanClose:= True;
			end;
		end
	else
		CanClose:= True;
	end;

procedure TTildaDesignNewAppForm.FormShow(Sender: TObject);
	begin
	ValueListEditor1.Values['Module Ident']:= 'mod_untitled_app';
	ValueListEditor1.Values['UInterface Ident']:= 'uni_untitled_ui';
	ValueListEditor1.Values['Layer Ident']:= 'lay_untitled_bkg';
	ValueListEditor1.Values['View Ident']:= 'vew_untitled_main';

	ValueListEditor1.Values['Screen Width']:= '80';
	ValueListEditor1.Values['Screen Height']:= '25';

	ActiveControl:= ValueListEditor1;
	end;


end.

