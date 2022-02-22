unit FrameTildaDesignLayer;

{$mode Delphi}

interface

uses
	Classes, SysUtils, Forms, Controls, Graphics, Dialogs, FrameTildaDesignEdit;

type
	{ TTildaDesignLayerFrame }

	TTildaDesignLayerFrame = class(TTildaDesignEditFrame)
	private

	public
		class procedure RegisterEditor; override;
	end;

implementation

{$R *.lfm}

uses
	TildaDesignTypes, TildaDesignClasses;

{ TTildaDesignLayerFrame }

class procedure TTildaDesignLayerFrame.RegisterEditor;
	begin
	TTildaDesignClass.Create(TTildaLayer, Self);
	end;


initialization
	TTildaDesignLayerFrame.RegisterEditor


end.

