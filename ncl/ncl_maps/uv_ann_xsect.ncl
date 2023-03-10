; 2-up plot of a scalar and vector variable

mapfile = "uv_xsect_1991-2020_ltm"

uvecvar = "u"
vvecvar = "v"
wvar = "w"
data_path = "../../data/ERA5-Atm/ltm_monthly_4D/"
data_path1 = "../../data/ERA5-Atm/ltm_monthly/"
map_path = "../../content/anim/ltm/xsect/" + mapfile + "/png/"

title_0 = "E-W Component of Wind (m s~S~-1~N~)"
title_1 = "N-S Component of Wind (m s~S~-1~N~)"
title_2 = "Data: ERA5 Reanalysis"
title_3 = "1991-2020 Long-Term Mean"

uinfile = "ERA5_u_monthly_199101-202012_ltm.nc"
vinfile = "ERA5_v_monthly_199101-202012_ltm.nc"
winfile = "ERA5_w_monthly_199101-202012_ltm.nc"

; set color scale
clr_map = "ClimA7"

nm = 12
months = (/"Jan", "Feb", "Mar", "Apr","May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov","Dec" /)

begin

; open file and read data
f0 = addfile(data_path + uinfile, "r")
u_in = short2flt(f0->$uvecvar$(:,:,:,:))
lon = f0->longitude
lat = f0->latitude
level = f0->level
time = f0->time
printVarSummary(u_in)
printMinMax(u_in, 1)

u = dim_avg_n_Wrap(u_in, 0)
printVarSummary(u)
printMinMax(u, 1)

f1 = addfile(data_path + vinfile, "r")
v_in = short2flt(f1->$vvecvar$(:,:,:,:))
printVarSummary(v_in)
printMinMax(v_in, 1)

v = dim_avg_n_Wrap(v_in, 0)
printVarSummary(v)
printMinMax(v, 1)

; ; create a new v array minus first four levels
; v2 = v(:,4:36,:,:)
; printVarSummary(v2)

; v2_level = v2&level
; delete(v2&level)
; v2_level = v2_level * 100.0
; v2_level&level = v2_level
; v2_level_at_units = "Pa"
; v2&level = v2_level 
; print(v2&level)
; printVarSummary(v2)

f2 = addfile(data_path + winfile, "r")
w_in = short2flt(f2->$wvar$(:,:,:,:))
printVarSummary(w_in)
printMinMax(w_in, 1)

w = dim_avg_n_Wrap(w_in, 0)
printVarSummary(w)
printMinMax(w, 1)

; f2 = addfile(data_path1 + psinfile, "r")
; ps = short2flt(f2->$psvar$(:,:,:))
; printVarSummary(ps)
; printMinMax(ps, 1)

; color table (Red to Blue)
colors = (/ "(/1.00, 1.00, 1.00/)", "(/0.00, 0.00, 0.00/)", \
    "(/0.655, 0.000, 0.000/)", "(/0.804, 0.000, 0.000/)", "(/1.000, 0.000, 0.000/)", \
    "(/1.000, 0.259, 0.259/)", "(/1.000, 0.475, 0.475/)", "(/1.000, 0.655, 0.655/)", \
    "(/1.000, 0.804, 0.804/)", "(/1.000, 0.875, 0.875/)", "(/1.000, 0.918, 0.918/)", \
    "(/0.918, 0.918, 1.000/)", "(/0.875, 0.875, 1.000/)", "(/0.804, 0.804, 1.000/)", \
    "(/0.655, 0.655, 1.000/)", "(/0.475, 0.475, 1.000/)", "(/0.259, 0.259, 1.000/)", \
    "(/0.000, 0.000, 1.000/)", "(/0.000, 0.000, 0.804/)", "(/0.000, 0.000, 0.655/)" /) 
; u 
; level0 = new((/ 11 /),float)
; level0 = (/ -20.0, -10., -5, -2, -1, 0.0, 1.0, 2.0, 5.0, 10.0, 20.0 /)
; level0 = (/ -25.0, -20.0, -15.0, -10.0, -5.0, 0.0, 5.0, 10.0, 15.0, 20.0, 25.0 /)
; level0_begclr = 120
; level0_endclr = 131
level0 = new((/ 17 /),float)
level0 = (/ -40.0,-35.0,-30.0,-25.0,-20.0,-15.0,-10.0,-5.0,0.0,5.0,10.0,15.0,20.0,25.0,30.0,35.0,40.0 /)

; ps1 
; level1 = new((/ 11 /),float)
; level1 = (/ -2.5, -2.0, -1.5, -1.0, -0.5, 0.0, 0.5, 1.0, 1.5, 2.0, 2.5 /)
; level1_begclr = 120
; level1_endclr = 131
level1 = new((/ 17 /),float)
level1 = (/ -2.0, -1.75, -1.5, -1.25, -1.0, 0.75, -0.5, 0.25, 0.0, 0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0 /)

; average zonal wind
uave = dim_avg_Wrap(u)
printVarSummary(uave)
printMinMax(uave, 1)

; average meridional wind
vave = dim_avg_Wrap(v)
printVarSummary(vave)
printMinMax(vave, 1)
; smooth vave a little
vave = smth9_Wrap(vave, 0.5, 0.25, True)
vave = smth9_Wrap(vave, 0.5, 0.25, True)
vave = smth9_Wrap(vave, 0.5, 0.25, True)

; average vertical wind
wave = dim_avg_Wrap(w)
printVarSummary(wave)
printMinMax(wave, 1)

; scale omega for plotting
wave = wave * -20.0

; ; meridional mass streamfunction
; plev = level(4:36)*100.0
; print(plev)

; psi = zonal_mpsi(v2,lat,plev,ps)   ; calculate the zonal mean msf
; printVarSummary(psi)
; psi = psi * 1.e-11                 ; from h_lat_1.ncl
; psi!0 = "time"
; psi!1   = "level"                   ; name the coordinates since
; psi!2   = "latitude"                    ; zmmsf does not copy them.
; psi&time = time
; psi&level = plev / 100.0
; psi&level@units = "hPa"
; psi&latitude = lat                      ; cp lat to "lat"  
; psi@long_name = "Zonal Mean Meridional Stream Function"
; printVarSummary(psi)
; printMinMax(psi, 1)

; ; try crude latitude smoothing
; ; do i = 0,19
; ;     psi(:,:,i) = psi(:,:,20)
; ; end do
; ; psi&latitude = lat                      ; cp lat to "lat"  
; psi = smth9_Wrap(psi, 0.5, 0.25, True)
; psi = smth9_Wrap(psi, 0.5, 0.25, True)
; printVarSummary(psi)

;  ; plotting resources

res                        = True  ; plot mods desired
plot = new(2, graphic)

; gsn high-level interfaces ---------------------------------------------------
res@gsnDraw                = False              ; don't draw
res@gsnFrame               = False              ; don't advance frame
res@gsnSpreadColors        = True               ; use total colormap
 
; aspect ratio
res@vpHeightF = 0.3 
res@vpWidthF = 0.6

; ; contour ----------------------------------------------------------------------
; res@cnLevelSelectionMode   = "ExplicitLevels" ;
res@cnLevelSelectionMode = "ManualLevels" ;
; res@cnLevelSpacingF      = 5.0                  ; contour spacing
; res@cnMinLevelValF       = -40.                 ; min level
; res@cnMaxLevelValF       =  40.                 ; max level 
res@cnLineLabelsOn       = False                 ; turn on line labels
res@cnFillOn             = True                 ; turn on color fill
res@cnLabelMasking             = True     
res@cnLineLabelBackgroundColor = "transparent"
res@cnLineLabelFontHeightF = 0.008
; res@cnSmoothingOn = True 
; res@cnSmoothingTensionF = -2.0

; y-axis labels
res@tiYAxisString = "Pressure Level (hPa)"
res@tiYAxisFontHeightF = 0.012

; tick marks
res@tmXBLabelFontHeightF = 0.01
res@tmYRLabelFontHeightF = 0.01
res@tmYLLabelFontHeightF = 0.01
res@tmXBMajorLengthF = 0.01
res@tmXBMinorLengthF = 0.005
res@tmXBLabelDeltaF = -0.6
res@tmYLLabelDeltaF = -0.6
res@tmYRLabelDeltaF = -0.6

;res@gsnScalarContour      = True               ; contours desired
; res@mpGridLineColor        = "transparent"      ; trick ncl into drawing perimeter
; res@cnInfoLabelOn          = False              ; turn off cn info label
; res@cnFillOn               = True               ; color fill  
; res@cnLinesOn              = False              ; no contour lines
; res@cnLineLabelsOn         = False              ; no contour labels
; res@cnInfoLabelOn          = False              ; no contour info label
; res@cnFillMode             = "RasterFill" ; or "CellFill"

; res@cnMissingValFillColor  = "gray" 

; label bar --------------------------------------------------------------------
res@lbLabelBarOn            = True            
res@pmLabelBarHeightF       = 0.05
res@lbLabelFontHeightF      = 0.0075
res@pmLabelBarOrthogonalPosF= -.001
res@lbBoxLineThicknessF     = 2
  
; res@gsnSpreadColorStart     = level0_begclr
; res@gsnSpreadColorEnd       = level0_endclr 
; res@cnLevels                = level0 

; titles---------------------------------------------------------------------- 
res@gsnLeftString           = ""
res@gsnRightString          = "" 
res@gsnLeftStringFontHeightF = 0.015
res@gsnRightStringFontHeightF = 0.015
txres1     = True

; vectors ---------------------------------------------------------------------
vcres = True
vcres = res
; res@gsnScalarContour      = True               ; contours desired
vcres@vcRefMagnitudeF = 0.3
vcres@vcMinFracLengthF = 0.1  ;-- length of min vector as fraction of reference vector
vcres@vcRefLengthF = 0.02 ;-- ref vec length
vcres@vcRefAnnoOrthogonalPosF = -0.08         ; move ref vector up
vcres@vcRefAnnoParallelPosF = 0.10         ; move ref vector over
vcres@vcGlyphStyle = "CurlyVector" ; "LineArrow" ;  ;-- turn on curly vectors or straight
vcres@vcGlyphOpacityF = 0.5 ;-- transparency of vector
vcres@vcMinDistanceF =  0.01 ; 0.008 ; 0.015 ; 0.02 ;-- thin out vectors
vcres@vcLineArrowColor = "black" ; "gray40" ; 
vcres@vcLineArrowThicknessF = 2.0
vcres@vcLineArrowHeadMinSizeF = 0.005 ;0.001
vcres@vcLineArrowHeadMaxSizeF = 0.010 ;0.004
vcres@vcRefAnnoString1 = ""
; res@vcRefAnnoFontHeightF = 0.007
; res@vcRefAnnoString1On = False 
vcres@vcRefAnnoString2On = False
vcres@vcRefAnnoPerimOn = False ; "True"
; res@vcRefAnnoBackgroundColor = "white" ; gray95
; ; res@vcLabelBarEndLabelsOn = "True"

; do m = 0,nm-1

    ; output format ----------------------------------------------------------------
    ; wks_type = "pdf"
    ; wks_type@wkOrientation = "portrait"
    wks_type = "png"
    wks_type@wkWidth = 750
    wks_type@wkHeight = 750

    ; monthstring  = sprinti("%0.2i", m+1)
    map_out_file = mapfile + "_" + "ann"

    wks  = gsn_open_wks (wks_type, map_path + map_out_file)
    print("     map_out_file: " + map_out_file + ".png")
    ; gsn_define_colormap(wks,clr_map)
    gsn_define_colormap(wks,colors)
    ; drawNDCGrid(wks)                   ; Draw an NDC grid for reference

    txres1@txFontHeightF = 0.010
    title_x_pos = 0.06
    title_y_pos = 0.01
    txres1@txJust        = "BottomLeft" 
    gsn_text_ndc(wks,title_2,title_x_pos,title_y_pos,txres1)
    title_x_pos = 0.94
    txres1@txJust        = "BottomRight" 
    gsn_text_ndc(wks,title_3,title_x_pos,title_y_pos,txres1)

    resp = res
    resp@gsnRightString = "Ann"
    resp@gsnLeftString = title_0
    ; resp@gsnSpreadColorStart     = level0_begclr
    ; resp@gsnSpreadColorEnd       = level0_endclr 
    ; resp@cnLevels                = level0 
    resp@cnLevelSpacingF      = 5.0                  ; contour spacing
    resp@cnMinLevelValF       = -40.                 ; min level
    resp@cnMaxLevelValF       =  40.                 ; max level 
    resp@gsnContourZeroLineThicknessF = 2.0           ; zero-line thinkness
    plot(0) = gsn_csm_pres_hgt(wks,uave(10:36,:),resp)
    delete(resp)

    txres1@txFontHeightF = 0.01
    label_1 = "E to W"
    label_x_pos = 0.23
    label_y_pos = 0.535
    txres1@txJust        = "BottomRight" 
    gsn_text_ndc(wks,label_1,label_x_pos,label_y_pos,txres1)
    label_2 = "W to E"
    label_x_pos = 0.775
    txres1@txJust        = "BottomLeft" 
    gsn_text_ndc(wks,label_2,label_x_pos,label_y_pos,txres1)

    resp = vcres
    resp@gsnRightString = "Ann"
    resp@gsnLeftString = title_1
    ; resp@gsnSpreadColorStart     = level1_begclr
    ; resp@gsnSpreadColorEnd       = level1_endclr 
    ; resp@cnLevels                = level1 
    resp@cnLevelSpacingF      = 0.25               ; contour spacing
    resp@cnMinLevelValF       = -4.                 ; min level
    resp@cnMaxLevelValF       =  4.                 ; max level 
    resp@gsnContourZeroLineThicknessF = 2.0           ; zero-line thinkness
    ; plot(1) = gsn_csm_pres_hgt(wks,vave(m,10:36,:),resp)
    plot(1) = gsn_csm_pres_hgt_vector(wks,vave(10:36,:),vave(10:36,0:720:16),wave(10:36,0:720:16),resp)
    delete(resp)

    txres1@txFontHeightF = 0.01
    label_1 = "N to S"
    label_x_pos = 0.23
    label_y_pos = 0.045
    txres1@txJust        = "BottomRight" 
    gsn_text_ndc(wks,label_1,label_x_pos,label_y_pos,txres1)
    label_2 = "S to N"
    label_x_pos = 0.775
    txres1@txJust        = "BottomLeft" 
    gsn_text_ndc(wks,label_2,label_x_pos,label_y_pos,txres1)

    ; resp = res
    ; resp@gsnRightString = months(m)
    ; resp@gsnLeftString = title_1
    ; ; resp@gsnSpreadColorStart     = level1_begclr
    ; ; resp@gsnSpreadColorEnd       = level1_endclr 
    ; ; resp@cnLevels                = level1 
    ; resp@cnLevelSpacingF      = 0.25                 ; contour spacing
    ; resp@cnMinLevelValF       = -2.0                 ; min level
    ; resp@cnMaxLevelValF       =  2.0                 ; max level 
    ; resp@gsnContourZeroLineThicknessF = 2.0           ; zero-line thinkness
    ; plot(1) = gsn_csm_pres_hgt(wks,psi(m,6:32,:),resp)
    ; delete(resp)

    ; txres1@txFontHeightF = 0.01
    ; label_1 = "Southward (CCW)"
    ; label_x_pos = 0.23
    ; label_y_pos = 0.045
    ; txres1@txJust        = "BottomRight" 
    ; gsn_text_ndc(wks,label_1,label_x_pos,label_y_pos,txres1)
    ; label_2 = "Northward (CW)"
    ; label_x_pos = 0.775
    ; txres1@txJust        = "BottomLeft" 
    ; gsn_text_ndc(wks,label_2,label_x_pos,label_y_pos,txres1)


    ; panel plot
    resP           = True
    resP@gsnPaperOrientation = "portrait"   
    resP@gsnPanelLeft  = 0.01 
    resP@gsnPanelRight = 0.99 
    resP@gsnPanelTop   = 0.99 
    resP@gsnPanelBottom = 0.01    
    resP@gsnPanelYWhiteSpacePercent = 1 ; 2

    gsn_panel(wks, plot, (/2,1/), resP)

; end do

end 

exit()