#!/usr/bin/env python3.13
if(c:=input()).isascii()*~-any(x in(c)for(x)in'!"#\'()*+-:<>@[]\\_{}'):exec(c[:43])