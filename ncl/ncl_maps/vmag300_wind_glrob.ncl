; 2-up plot of a scalar and vector variable

mapfile = "vmag300_wind_globe_1991-2020_ltm"
ncvar = "vmag300"
mapvar = "vmag300"
umapvar = "u300"
vmapvar = "v300"
uvecvar = "u"
vvecvar = "v"
data_path = "../../data/ERA5-Atm/ltm_monthly/"
map_path = "../../content/anim/ltm/globe/" + mapfile + "/png/"
title_0 = "300 hPa Winds Speed (m s~S~-1~N~)"
title_2 = "Data: ERA5 Reanalysis"
title_3 = "1991-2020 Long-Term Mean"

infile = "ERA5_" + mapvar + "_monthly_199101-202012_ltm.nc"
uinfile = "ERA5_" + umapvar + "_monthly_199101-202012_ltm.nc"
vinfile = "ERA5_" + vmapvar + "_monthly_199101-202012_ltm.nc"

; shapefiles
land_dir = "../../shp_files/"
land_file = "ERA5-Atm_land.shp"
land_shp = land_dir + land_file
print(land_shp)
country_dir = "../../shp_files/ne_110m_admin_0_countries/"
country_file = "ne_110m_admin_0_countries.shp"
country_shp = country_dir + country_file
print(country_shp)

; set color scale
clr_map = "ClimA7"

nm = 12
months = (/"Jan", "Feb", "Mar", "Apr","May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov","Dec" /)

begin

; open file and read data
f1 = addfile(data_path + infile, "r")
pltvar = short2flt(f1->$ncvar$(:,:,:))
pltvar = pltvar 
lon = f1->longitude
lat = f1->latitude
time = f1->time
pltvar = lonFlip(pltvar)
printVarSummary(pltvar)
printMinMax(pltvar, 1)
f2 = addfile(data_path + uinfile, "r")
u = short2flt(f2->$uvecvar$(:,:,:))
u = lonFlip(u)
f3 = addfile(data_path + vinfile, "r")
v = short2flt(f3->$vvecvar$(:,:,:))
v = lonFlip(v)

; u and v 10 m 
level0 = new((/ 06 /),float)
level0 = (/ 0.0, 1.0, 2.0, 5.0, 10.0, 20.0 /)
level0_begclr = 125
level0_endclr = 131

; plotting resources

res                        = True  ; plot mods desired
plot = new(1, graphic)
id_land = new(1, graphic)
id_country = new(1, graphic)

; gsn high-level interfaces ---------------------------------------------------
res@gsnDraw                = False              ; don't draw
res@gsnFrame               = False              ; don't advance frame
res@gsnSpreadColors        = True               ; use total colormap
 
; contour ----------------------------------------------------------------------
;res@gsnScalarContour      = True               ; contours desired
res@mpGridLineColor        = "transparent"      ; trick ncl into drawing perimeter
res@cnInfoLabelOn          = False              ; turn off cn info label
res@cnFillOn               = True               ; color fill  
res@cnLinesOn              = False              ; no contour lines
res@cnLineLabelsOn         = False              ; no contour labels
res@cnInfoLabelOn          = False              ; no contour info label
res@cnFillMode             = "CellFill"; "RasterFill" or "CellFill"
res@cnLevelSelectionMode   = "ExplicitLevels" ;
res@cnMissingValFillColor  = "gray" 

; maps -------------------------------------------------------------------------
res@mpOutlineOn            = False     ; continental outline
res@mpFillOn               = False       ; turn off map fill
res@mpGridAndLimbOn        = True      ; Turn on lat/lon grid
res@mpPerimOn              = False      ; turn off perimeter  
res@mpProjection           = "Robinson"       ; choose map projection

res@mpLimbLineThicknessF    = 2
res@mpGridLatSpacingF       = 30
res@mpGridLonSpacingF       = 30 
res@mpGridLineColor         = "gray50"
res@mpGridLineThicknessF    = 1

res@mpLimitMode             = "LatLon" ; use lat/lon coordinates to limit area
res@mpMinLatF               =  -90. 
res@mpMaxLatF               =   90. 
res@mpMinLonF               =  -180. 
res@mpMaxLonF               =   180.

; vectors ---------------------------------------------------------------------
res@gsnScalarContour      = True               ; contours desired
res@vcRefMagnitudeF = 20.0
res@vcMinFracLengthF = 0.1  ;-- length of min vector as fraction of reference vector
res@vcRefLengthF = 0.02 ;-- ref vec length
res@vcRefAnnoOrthogonalPosF = -0.11          ; move ref vector up
res@vcRefAnnoParallelPosF = 0.10         ; move ref vector over
res@vcGlyphStyle = "CurlyVector" ; "LineArrow" ;  ;-- turn on curly vectors or straight
res@vcGlyphOpacityF = 0.5 ;-- transparency of vector
res@vcMinDistanceF = 0.008 ; 0.015 ; 0.02 ;-- thin out vectors
res@vcLineArrowColor = "black" ; "gray40" ; 
res@vcLineArrowThicknessF = 2.0
res@vcLineArrowHeadMinSizeF = 0.001
res@vcLineArrowHeadMaxSizeF = 0.004
res@vcRefAnnoString1 = "20 m s~S~-1~N~"
res@vcRefAnnoFontHeightF = 0.007
res@vcRefAnnoPerimOn = False ; "True"
res@vcRefAnnoBackgroundColor = "white" ; gray95
; res@vcLabelBarEndLabelsOn = "True"

; label bar --------------------------------------------------------------------
res@lbLabelBarOn            = True            
res@pmLabelBarHeightF       = 0.04
res@lbLabelFontHeightF      = 0.00625
res@pmLabelBarOrthogonalPosF= -.001
res@lbBoxLineThicknessF     = 2
  
res@gsnSpreadColorStart     = level0_begclr
res@gsnSpreadColorEnd       = level0_endclr 
res@cnLevels                = level0 

; titles---------------------------------------------------------------------- 
res@gsnLeftString           = ""
res@gsnRightString          = "" 
txres1     = True

; shapefile outlines -------------------------------------------------------
plres        = True
plres@gsLineColor = "black"
plres@gsLineThicknessF= 1
pcres        = True
pcres@gsLineColor = "gray50"
pcres@gsLineThicknessF= 0.5

do m = 0,nm-1

    ; output format ----------------------------------------------------------------
    ; wks_type = "pdf"
    ; wks_type@wkOrientation = "portrait"
    wks_type = "png"
    wks_type@wkWidth = 1200
    wks_type@wkHeight = 1200

    monthstring  = sprinti("%0.2i", m+1)
    map_out_file = mapfile + "_" + monthstring
    wks  = gsn_open_wks (wks_type, map_path + map_out_file)
    print("     map_out_file: " + map_out_file + ".png")
    gsn_define_colormap(wks,clr_map)
    ; drawNDCGrid(wks)                   ; Draw an NDC grid for reference

    title_1         = months(m)

    ; plot titles
    txres1@txFont        = 21 
    txres1@txFontHeightF = 0.0175
    title_x_pos = 0.01
    title_y_pos = 0.8
    txres1@txJust        = "CenterLeft" 
    gsn_text_ndc(wks,title_0,title_x_pos,title_y_pos,txres1)
    title_y_pos = 0.81
    title_x_pos = 0.99
    txres1@txJust        = "TopRight" 
    gsn_text_ndc(wks,title_1,title_x_pos,title_y_pos,txres1)  

    txres1@txFontHeightF = 0.010
    title_x_pos = 0.01
    title_y_pos = 0.22
    txres1@txJust        = "BottomLeft" 
    gsn_text_ndc(wks,title_2,title_x_pos,title_y_pos,txres1)
    title_x_pos = 0.99
    txres1@txJust        = "BottomRight" 
    gsn_text_ndc(wks,title_3,title_x_pos,title_y_pos,txres1)

    ; plot(0) = gsn_csm_contour_map(wks, pltvar(m,:,:), res)
    ; note thinning of vectors
    plot(0) = gsn_csm_vector_scalar_map(wks,u(m,::2,::2),v(m,::2,::2),pltvar(m,:,:),res)
    id_country(0) = gsn_add_shapefile_polylines(wks,plot(0),country_shp,pcres)
    id_land(0) = gsn_add_shapefile_polylines(wks,plot(0),land_shp,plres)

    ; panel plot
    resP           = True
    resP@gsnPaperOrientation = "portrait"   
    resP@gsnPanelLeft  = 0.01 
    resP@gsnPanelRight = 0.99 
    resP@gsnPanelTop   = 0.99 
    resP@gsnPanelBottom = 0.01    
    resP@gsnPanelYWhiteSpacePercent = 1 ; 2

    gsn_panel(wks, plot, (/1,1/), resP)

end do
end 

exit()