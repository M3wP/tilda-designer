unit FormTildaDesignSelOptions;

{$mode Delphi}
{$H+}

interface

uses
	Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
	StdCtrls, TildaDesignTypes;

type

	{ TTildaDesignSelOptionsForm }

	TTildaDesignSelOptionsForm = class(TForm)
		BitBtn1: TBitBtn;
		BitBtn2: TBitBtn;
		CheckBox1: TCheckBox;
		CheckBox2: TCheckBox;
		CheckBox3: TCheckBox;
		CheckBox4: TCheckBox;
		CheckBox5: TCheckBox;
		CheckBox6: TCheckBox;
		CheckBox7: TCheckBox;
		CheckBox8: TCheckBox;
		CheckBox9: TCheckBox;
		Panel2: TPanel;
		procedure CheckBox1Change(Sender: TObject);
	private
		FSelected: TTildaOptions;

	public
		function ShowSelSetOptions(const AOptions: TTildaOptions): TModalResult;

		property Selected: TTildaOptions read FSelected;
	end;

var
	TildaDesignSelOptionsForm: TTildaDesignSelOptionsForm;

implementation

{$R *.lfm}

{ TTildaDesignSelOptionsForm }

procedure TTildaDesignSelOptionsForm.CheckBox1Change(Sender: TObject);
	var
	o: TTildaOptionKind;

	begin
	o:=  TTildaOptionKind((Sender as TCheckbox).Tag);

	if  (Sender as TCheckbox).Checked then
		Include(FSelected, o)
	else
		Exclude(FSelected, o);
	end;

function TTildaDesignSelOptionsForm.ShowSelSetOptions(
		const AOptions: TTildaOptions): TModalResult;
	begin
	CheckBox1.Checked:= tokNoAutoInvl in AOptions;
	CheckBox2.Checked:= tokNoNavigate in AOptions;
	CheckBox3.Checked:= tokNoDownActv in AOptions;
	CheckBox4.Checked:= tokDownCapture in AOptions;
	CheckBox5.Checked:= tokAutoCheck in AOptions;
	CheckBox6.Checked:= tokTextAccel2X in AOptions;
	CheckBox7.Checked:= tokTextContMrk in AOptions;
	CheckBox8.Checked:= tokNoAutoChkOf in AOptions;
	CheckBox9.Checked:= tokAutoTrack in AOptions;

	FSelected:= AOptions;

	Result:= ShowModal;
	end;

end.

