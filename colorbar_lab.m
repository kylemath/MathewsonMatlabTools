function colorbar_lab(label)

cb = colorbar; %a colormap menu is added to your figure
set(get(cb,'ylabel'),'string',label)