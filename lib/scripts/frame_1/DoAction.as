function reset()
{
   pages.p0.page._x = - pw;
   pages.p0._x = 0;
   pages.p1.page._x = - pw;
   pages.p1._x = 0;
   pages.flip.p2.page._x = - pw;
   pages.flip.p2._x = pw;
   pages.flip.p3.page._x = - pw;
   pages.flip.p3._x = 0;
   pages.p4.page._x = - pw;
   pages.p4._x = pw;
   pages.p5.page._x = - pw;
   pages.p5._x = pw;
   pages.pgrad._visible = pages.mask._visible = pages.flip._visible = false;
   pages.flip.p3mask._width = pages.pgmask._width = pw * 2;
   pages.center._height = pages.flip.p3mask._height = pages.pgmask._height = ph;
   pages.flip.fmask.page.pf._width = pw;
   pages.center._width = 6;
   pages.flip.fmask.page.pf._height = ph;
   pageNumber = new Array();
   i = 0;
   while(i <= maxPage + 1)
   {
      pageNumber[i] = i;
      i++;
   }
}
function hittest()
{
   var x = pages._xmouse;
   var y = pages._ymouse;
   var pmh = ph / 2;
   if(!(y <= pmh && y >= - pmh && x <= pw && x >= - pw))
   {
      return 0;
   }
   var r = Math.sqrt(x * x + y * y);
   var a = Math.asin(y / r);
   var y = Math.tan(a) * pw;
   if(y > 0 && y > ph / 2)
   {
      y = ph / 2;
   }
   if(y < 0 && y < (- ph) / 2)
   {
      y = (- ph) / 2;
   }
   oy = sy = y;
   r0 = Math.sqrt((sy + ph / 2) * (sy + ph / 2) + pw * pw);
   r1 = Math.sqrt((ph / 2 - sy) * (ph / 2 - sy) + pw * pw);
   pageN = pages.flip.p2.page;
   pageO = pages.flip.p3;
   offs = - pw;
   pages.flip.fmask._x = pw;
   if(x < - (pw - clickarea) && page > 0)
   {
      pages.flip.p3._x = 0;
      hflip = checkCover(page,-1);
      setPages(page - 2,page - 1,page,page + 1);
      ctear = pageCanTear[page - 1];
      return -1;
   }
   if(x > pw - clickarea && page < maxpage)
   {
      pages.flip.p3._x = pw;
      hflip = checkCover(page,1);
      setPages(page,page + 2,page + 1,page + 3);
      ctear = pageCanTear[page + 2];
      return 1;
   }
}
function checkCover(p, dir)
{
   if(hcover)
   {
      if(dir > 0)
      {
         if(p == maxpage - 2 || p == 0)
         {
            return true;
         }
      }
      else if(p == maxpage || p == 2)
      {
         return true;
      }
   }
   return false;
}
function corner()
{
   var x = Math.abs(pages._xmouse);
   var y = Math.abs(pages._ymouse);
   if(x > pw - afa && x < pw && y > ph / 2 - afa && y < ph / 2)
   {
      return true;
   }
   return false;
}
function oef()
{
   _global.mcnt++;
   if(!flip && corner())
   {
      preflip = true;
      if(!autoflip())
      {
         preflip = false;
      }
   }
   if(preflip && !corner())
   {
      preflip = false;
      flip = false;
      flipOK = false;
      flipoff = true;
   }
   getm();
   if(aflip && !preflip)
   {
      y = ay += (sy - ay) / (!gflip ? ps : gs);
      acnt += aadd;
      ax -= aadd;
      if(Math.abs(acnt) > pw)
      {
         flipOK = true;
         flipOff = true;
         flip = false;
         aflip = false;
      }
   }
   if(flip)
   {
      if(tear)
      {
         x = tox;
         y = toy += teard;
         teard *= 1.2;
         if(Math.abs(teard) > 1200)
         {
            flipOff = true;
            flip = false;
         }
      }
      else
      {
         x = ox += (x - ox) / (!gflip ? ps : gs);
         y = oy += (y - oy) / (!gflip ? ps : gs);
      }
      calc(x,y);
   }
   if(flipOff)
   {
      if(flipOK || tear)
      {
         x = ox += (- sx - ox) / (!gflip ? es : gs);
         y = oy += (sy - oy) / (!gflip ? es : gs);
         calc(x,y);
         if(x / (- sx) > 0.99 || tear)
         {
            flip = false;
            flipOK = flipOff = false;
            pages.pgrad._visible = pages.flip._visible = false;
            if(tear)
            {
               removePage(sx >= 0 ? page + 1 : page);
               page += sx >= 0 ? 0 : -2;
            }
            else
            {
               page += sx >= 0 ? 2 : -2;
            }
            setPages(page,0,0,page + 1);
            tear = false;
            if(gpage > 0)
            {
               gpage--;
               autoflip();
            }
            else
            {
               gflip = false;
            }
         }
      }
      else
      {
         x = ox += (sx - ox) / 3;
         y = oy += (sy - oy) / 3;
         calc(x,y);
         if(x / sx > 0.99)
         {
            flip = false;
            flipOff = false;
            aflip = false;
            pages.pgrad._visible = pages.flip._visible = false;
            setPages(page,0,0,page + 1);
         }
      }
   }
}
function calc(x, y)
{
   if(hflip)
   {
      var xp = sx >= 0 ? x : - x;
      if(xp > 0)
      {
         sp2._visible = false;
         sp3._visible = true;
         scalc(sp3,x);
      }
      else
      {
         sp3._visible = false;
         sp2._visible = true;
         scalc(sp2,x);
      }
      pages.flip.setMask(null);
      pages.flip._visible = true;
      pages.flip.fgrad._visible = false;
      pages.flip.p2._visible = pages.flip.p3._visible = false;
      return undefined;
   }
   pages.flip.fgrad._visible = true;
   var rr0 = Math.sqrt((y + ph / 2) * (y + ph / 2) + x * x);
   var rr1 = Math.sqrt((ph / 2 - y) * (ph / 2 - y) + x * x);
   if((rr0 > r0 || rr1 > r1) && !tear)
   {
      if(y < sy)
      {
         var a = Math.asin((ph / 2 - y) / rr1);
         y = ph / 2 - Math.sin(a) * r1;
         x = x >= 0 ? Math.cos(a) * r1 : (- Math.cos(a)) * r1;
         if(y > sy)
         {
            if(sx * x > 0)
            {
               y = sy;
               x = sx;
            }
            else
            {
               y = sy;
               x = - sx;
            }
         }
         if(rr1 - r1 > tlimit && ctear)
         {
            teard = -5;
            tear = true;
            tox = ox = x;
            toy = oy = y;
         }
      }
      else
      {
         var a = Math.asin((y + ph / 2) / rr0);
         y = Math.sin(a) * r0 - ph / 2;
         x = x >= 0 ? Math.cos(a) * r0 : (- Math.cos(a)) * r0;
         if(y < sy)
         {
            if(sx * x > 0)
            {
               y = sy;
               x = sx;
            }
            else
            {
               y = sy;
               x = - sx;
            }
         }
         if(rr0 - r0 > tlimit && ctear)
         {
            teard = 5;
            tear = true;
            tox = ox = x;
            toy = oy = y;
         }
      }
   }
   if(sx < 0 && x - sx < 10 || sx > 0 && sx - x < 10)
   {
      if(sx < 0)
      {
         x = - pw + 10;
      }
      if(sx > 0)
      {
         x = pw - 10;
      }
   }
   pages.flip._visible = true;
   pages.flip.p3shadow._visible = pages.pgrad._visible = !tear;
   pages.flip.p2._visible = pages.flip.p3._visible = true;
   var vx = x - sx;
   var vy = y - sy;
   var a1 = vy / vx;
   var a2 = (- vy) / vx;
   cx = sx + vx / 2;
   cy = sy + vy / 2;
   var r = Math.sqrt((sx - x) * (sx - x) + (sy - y) * (sy - y));
   var a = Math.asin((sy - y) / r);
   if(sx < 0)
   {
      a = - a;
   }
   ad = a / AM;
   pageN._rotation = ad * 2;
   r = Math.sqrt((sx - x) * (sx - x) + (sy - y) * (sy - y));
   rl = pw * 2;
   if(sx > 0)
   {
      pages.mask._xscale = 100;
      nx = cx - Math.tan(a) * (ph / 2 - cy);
      ny = ph / 2;
      if(nx > pw)
      {
         nx = pw;
         ny = cy + Math.tan(1.5707963267948966 + a) * (pw - cx);
      }
      pageN.pf._x = - (pw - nx);
      pages.flip.fgrad._xscale = r / rl / 2 * pw;
      pages.pgrad._xscale = (- r / rl / 2) * pw;
      pages.flip.p3shadow._xscale = r / rl / 2 * pw;
   }
   else
   {
      pages.mask._xscale = -100;
      nx = cx - Math.tan(a) * (ph / 2 - cy);
      ny = ph / 2;
      if(nx < - pw)
      {
         nx = - pw;
         ny = cy + Math.tan(1.5707963267948966 + a) * (- pw - cx);
      }
      pageN.pf._x = - (pw - (pw + nx));
      pages.flip.fgrad._xscale = (- r / rl / 2) * pw;
      pages.pgrad._xscale = r / rl / 2 * pw;
      pages.flip.p3shadow._xscale = (- r / rl / 2) * pw;
   }
   pages.mask._x = cx;
   pages.mask._y = cy;
   pages.mask._rotation = ad;
   pageN.pf._y = - ny;
   pageN._x = nx + offs;
   pageN._y = ny;
   pages.flip.fgrad._x = cx;
   pages.flip.fgrad._y = cy;
   pages.flip.fgrad._rotation = ad;
   pages.flip.fgrad._alpha = r <= rl - 50 ? 100 : 100 - (r - (rl - 50)) * 2;
   pages.flip.p3shadow._x = cx;
   pages.flip.p3shadow._y = cy;
   pages.flip.p3shadow._rotation = ad;
   pages.flip.p3shadow._alpha = r <= rl - 50 ? 100 : 100 - (r - (rl - 50)) * 2;
   pages.pgrad._x = cx;
   pages.pgrad._y = cy;
   pages.pgrad._rotation = ad + 180;
   pages.pgrad._alpha = r <= rl - 100 ? 100 : 100 - (r - (rl - 100));
   pages.flip.fmask.page._x = pageN._x;
   pages.flip.fmask.page._y = pageN._y;
   pages.flip.fmask.page.pf._x = pageN.pf._x;
   pages.flip.fmask.page.pf._y = pageN.pf._y;
   pages.flip.fmask.page._rotation = pageN._rotation;
}
function scalc(obj, x)
{
   if(x < - pw)
   {
      x = - pw;
   }
   if(x > pw)
   {
      x = pw;
   }
   var a = Math.asin(x / pw);
   var rot = a / AM / 2;
   var xs = 100;
   var ss = 100 * Math.sin(rotz * AM);
   x /= 2;
   var y = Math.cos(a) * (pw / 2) * (ss / 100);
   placeImg(obj,rot,ss,x,y);
   pages.pgrad._visible = pages.flip._visible = true;
   pages.pgrad._xscale = x;
   pages.pgrad._alpha = pages.flip.p3shadow._alpha = 100;
   pages.flip.p3shadow._xscale = - x;
   pages.flip.p3shadow._x = 0;
   pages.flip.p3shadow._y = 0;
   pages.flip.p3shadow._rotation = 0;
   pages.pgrad._x = 0;
   pages.pgrad._y = 0;
   pages.pgrad._rotation = 0;
}
function placeImg(j, rot, ss, x, y)
{
   var m = Math.tan(rot * AM);
   var f = 1.4142135623730951 / Math.sqrt(m * m + 1);
   var phxs = 100 * m;
   var phRot = - rot;
   var xs = 100 * f;
   var ys = 100 * f;
   j.ph.pic._rotation = 45;
   j.ph.pic._xscale = phxs >= 0 ? xs : - xs;
   j.ph.pic._yscale = ys * (100 / ss);
   j.ph._rotation = phRot;
   j.ph._xscale = phxs;
   j._yscale = ss;
   j._x = x;
   j._y = y;
   j._visible = true;
}
function setPages(p1, p2, p3, p4)
{
   p0 = p1 - 2;
   p5 = p4 + 2;
   if(p0 < 0)
   {
      p0 = 0;
   }
   if(p5 > maxpage)
   {
      p5 = 0;
   }
   if(p1 < 0)
   {
      p1 = 0;
   }
   if(p2 < 0)
   {
      p2 = 0;
   }
   if(p3 < 0)
   {
      p3 = 0;
   }
   if(p4 < 0)
   {
      p4 = 0;
   }
   trace("setpages ->" + p1 + "," + p2 + "," + p3 + "," + p4);
   pleft = pages.p1.page.pf.ph.attachMovie(pageOrder[p1],"pic",0);
   pages.p1.page.pf.ph._y = (- ph) / 2;
   pleftb = pages.p0.page.pf.ph.attachMovie(pageOrder[p0],"pic",0);
   pages.p0.page.pf.ph._y = (- ph) / 2;
   if(hflip)
   {
      var tm = pages.flip.hfliph.attachMovie("sph","sp2",0);
      sp2 = tm.ph.pic.attachMovie(pageOrder[p2],"pic",0);
      sp2._y = (- ph) / 2;
      sp2._x = (- pw) / 2;
      sp2 = pages.flip.hfliph.sp2;
      var tm = pages.flip.hfliph.attachMovie("sph","sp3",1);
      sp3 = tm.ph.pic.attachMovie(pageOrder[p3],"pic",0);
      sp3._y = (- ph) / 2;
      sp3._x = (- pw) / 2;
      sp3 = pages.flip.hfliph.sp3;
   }
   else
   {
      pages.flip.hfliph.sp2.removeMovieClip();
      pages.flip.hfliph.sp3.removeMovieClip();
      sp2 = pages.flip.p2.page.pf.ph.attachMovie(pageOrder[p2],"pic",0);
      pages.flip.p2.page.pf.ph._y = (- ph) / 2;
      sp3 = pages.flip.p3.page.pf.ph.attachMovie(pageOrder[p3],"pic",0);
      pages.flip.p3.page.pf.ph._y = (- ph) / 2;
   }
   pright = pages.p4.page.pf.ph.attachMovie(pageOrder[p4],"pic",0);
   pages.p4.page.pf.ph._y = (- ph) / 2;
   prightb = pages.p5.page.pf.ph.attachMovie(pageOrder[p5],"pic",0);
   pages.p5.page.pf.ph._y = (- ph) / 2;
}
function resetPages()
{
   setPages(page,0,0,page + 1);
}
function autoflip()
{
   if(!(!aflip && !flip && !flipoff && canflip))
   {
      return false;
   }
   acnt = 0;
   aamp = Math.random() * (ph / 2) - ph / 4;
   var x = !gflip ? (pages._xmouse >= 0 ? pw / 2 : (- pw) / 2) : gdir * pw / 2;
   var y = Math.random() * ph - ph / 2;
   var pmh = ph / 2;
   var r = Math.sqrt(x * x + y * y);
   var a = Math.asin(y / r);
   var yy = Math.tan(a) * pw;
   if(y > 0 && y > ph / 2)
   {
      y = ph / 2;
   }
   if(y < 0 && y < (- ph) / 2)
   {
      y = (- ph) / 2;
   }
   oy = sy = yy;
   ax = pages._xmouse >= 0 ? pw / 2 : (- pw) / 2;
   var l = ph / 2 - y;
   ay = y;
   Math.random() * 2 * l - l;
   offs = - pw;
   var hit = 0;
   if(x < 0 && page > 0)
   {
      pages.flip.p3._x = 0;
      hflip = checkCover(page,-1);
      if(!(preflip && hflip))
      {
         setPages(page - 2,page - 1,page,page + 1);
      }
      hit = -1;
   }
   if(x > 0 && page < maxpage)
   {
      pages.flip.p3._x = pw;
      hflip = checkCover(page,1);
      if(!(preflip && hflip))
      {
         setPages(page,page + 2,page + 1,page + 3);
      }
      hit = 1;
   }
   if(hflip && preflip)
   {
      hit = 0;
      preflip = false;
      return false;
   }
   if(hit)
   {
      anim._visible = false;
      flip = true;
      flipOff = false;
      ox = sx = hit * pw;
      pages.flip.setMask(pages.mask);
      aadd = hit * (pw / (!gflip ? 10 : 5));
      aflip = true;
      pages.flip.fmask._x = pw;
      if(preflip)
      {
         oy = sy = pages._ymouse >= 0 ? ph / 2 : - ph / 2;
      }
      r0 = Math.sqrt((sy + ph / 2) * (sy + ph / 2) + pw * pw);
      r1 = Math.sqrt((ph / 2 - sy) * (ph / 2 - sy) + pw * pw);
      pageN = pages.flip.p2.page;
      pageO = pages.flip.p3;
      oef();
      return true;
   }
}
function getm()
{
   if(aflip && !preflip)
   {
      x = ax;
      y = ay;
   }
   else
   {
      x = pages._xmouse;
      y = pages._ymouse;
   }
}
function gotoPage(i)
{
   i = getPN(i);
   if(i < 0)
   {
      return false;
   }
   var p = int(page / 2);
   var d = int(i / 2);
   if(p != d && canflip && !gflip)
   {
      if(p < d)
      {
         gdir = 1;
         gpage = d - p - 1;
      }
      else
      {
         gdir = -1;
         gpage = p - d - 1;
      }
      gflip = true;
      autoflip();
   }
}
function getPN(i)
{
   var find = false;
   j = 1;
   while(j <= maxpage)
   {
      if(i == pageNumber[j])
      {
         i = j;
         find = true;
         break;
      }
      j++;
   }
   if(find)
   {
      return i;
   }
   return -1;
}
function removePage(i)
{
   trace("remove page " + i);
   i = Math.floor((i - 1) / 2) * 2 + 1;
   removedPages.push(pageNumber[i],pageNumber[i + 1]);
   j = i + 2;
   while(j <= maxPage + 1)
   {
      pageOrder[j - 2] = pageOrder[j];
      pageCanTear[j - 2] = pageCanTear[j];
      pageNumber[j - 2] = pageNumber[j];
      j++;
   }
   trace("removed pages " + i + "," + (i + 1));
   trace(removedPages.join(", "));
   maxPage -= 2;
}
trace(this);
trace(_root);
fscommand("fullscreen",true);
pw = 480;
ph = 650;
pageOrder = new Array("page0","page1","page2","page3","page4","page5","page6","page7","page8","page9","page10","page11","page12","page13","page14","page15","page16","page17","page18","page19","page20","page21","page22","page23","page24","page25","page26","page27","page28","page29","page30","page31","page32","page33","page34","page35","page36","page37","page38","page39","page40","page41","page42","page43","page44","page45","page46","page47","page48","page49","page50","page51","page52","page53");
page = 52;
maxpage = 52;
hcover = true;
clickarea = 64;
afa = 56;
gs = 2;
ps = 5;
es = 3;
canflip = true;
_global.mcnt = 0;
gpage = 0;
gflip = false;
gdir = 0;
aflip = false;
flip = false;
flipOff = false;
flipOK = false;
hflip = false;
rotz = -30;
preflip = false;
ctear = false;
tear = false;
teard = 0;
tlimit = 80;
removedPages = new Array();
mpx = 0;
mpy = 0;
sx = sy = 0;
x = 0;
y = 0;
ax = 0;
ay = 0;
acnt = 0;
aadd = 0;
aamp = 0;
AM = 0.017453292519943295;
stop();
_quality = "BEST";
Stage.scaleMode = "noScale";
mousecontroll = new Object();
mousecontroll.onMouseDown = function()
{
   if(flip && !aflip)
   {
      flipOK = false;
      if(sx < 0 && pages._xmouse > 0)
      {
         flipOK = true;
      }
      if(sx > 0 && pages._xmouse < 0)
      {
         flipOK = true;
      }
      flipOff = true;
      flip = false;
   }
   else if((flipoff || aflip || !canflip) && !preflip)
   {
      trace("donothing");
   }
   else
   {
      var oox = ox;
      var ooy = oy;
      var osx = sx;
      var osy = sy;
      var hit = hittest();
      if(hit)
      {
         anim._visible = false;
         flip = true;
         flipOff = false;
         tear = false;
         ox = sx = hit * pw;
         if(preflip)
         {
            aflip = preflip = false;
            ox = oox;
            oy = ooy;
            sx = osx;
            sy = osy;
         }
         pages.flip.setMask(pages.mask);
         mpx = pages._xmouse;
         mpy = pages._ymouse;
      }
   }
};
mousecontroll.onMouseUp = function()
{
   if(flip && !tear)
   {
      if(Math.abs(pages._xmouse) > pw - afa && Math.abs(pages._ymouse) > ph / 2 - afa && Math.abs(pages._xmouse - mpx) < afa || preflip)
      {
         flip = false;
         preflip = false;
         autoflip();
      }
      else if(!preflip)
      {
         preflip = false;
         flipOK = false;
         if(sx < 0 && pages._xmouse > 0)
         {
            flipOK = true;
         }
         if(sx > 0 && pages._xmouse < 0)
         {
            flipOK = true;
         }
         flipOff = true;
         flip = false;
      }
   }
};
onEnterFrame = function()
{
   trace(getBytesLoaded());
   if(getBytesLoaded() == getBytesTotal())
   {
      gotoAndPlay(2);
      delete onEnterFrame;
   }
};
