unit FormTildaDesignNewApp;

{$mode Delphi}
{$H+}

interface

uses
	Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ValEdit, ExtCtrls,
	StdCtrls, Buttons, Grids;

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
		procedure ValueListEditor1SetEditText(Sender: TObject; ACol,
			ARow: Integer; const Value: string);
		procedure ValueListEditor1ValidateEntry(sender: TObject; aCol,
			aRow: Integer; const OldValue: string; var NewValue: String);
	private
		FBaseName: string;

		procedure UpdateObjectNames;
	public
		property  BaseName: string read FBaseName;
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

	x: Cardinal;

	begin
	if  ModalResult = mrOK then
		begin
		FBaseName:= ValueListEditor1.Values['App Base Name'];

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
			if  h = 50 then
				x:= $2000
			else
				x:= 0;

			m:= TTildaModule.Create(mi, nil);
			u:= TTildaUInterface.Create(ui, m);

			u.mouseloc:= $00013000 + x;
			u.mptrloc:=  $00013200 + x;
			u.mousepal:= 1;

			l:= TTildaLayer.Create(li, u);
			l.width:= w;

			v:= TTildaView.Create(vi, u);
			v.cellsize:= 2;
			v.width:= w;
			v.height:= h;
			v.location:= $00012000 + x;

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
	ValueListEditor1.Values['App Base Name']:= 'untitled';
	UpdateObjectNames;

	ValueListEditor1.Values['Screen Width']:= '80';
	ValueListEditor1.Values['Screen Height']:= '25';

	ActiveControl:= BitBtn1;

	ValueListEditor1.Selection.Location:= Point(0, 1);
	ActiveControl:= ValueListEditor1;
	end;

procedure TTildaDesignNewAppForm.ValueListEditor1SetEditText(Sender: TObject;
		ACol, ARow: Integer; const Value: string);
	begin

	end;

procedure TTildaDesignNewAppForm.ValueListEditor1ValidateEntry(sender: TObject;
		aCol, aRow: Integer; const OldValue: string; var NewValue: String);
	begin
	if  CompareStr(ValueListEditor1.Keys[ARow], 'App Base Name') = 0 then
		if  IsValidIdent(NewValue) then
			begin
			ValueListEditor1.Values['App Base Name']:= NewValue;
			UpdateObjectNames;
			end;
	end;

procedure TTildaDesignNewAppForm.UpdateObjectNames;
	var
	n: string;

	begin
	n:= ValueListEditor1.Values['App Base Name'];
	ValueListEditor1.Values['Module Ident']:= 'mod_' + n + '_app';
	ValueListEditor1.Values['UInterface Ident']:= 'uni_' + n + '_ui';
	ValueListEditor1.Values['Layer Ident']:= 'lay_' + n + '_bkg';
	ValueListEditor1.Values['View Ident']:= 'vew_' + n + '_main';
	end;


end.

