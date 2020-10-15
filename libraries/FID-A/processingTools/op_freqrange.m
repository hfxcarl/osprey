% op_freqrange.m
% Jamie Near, McGill University 2014.
% 
% USAGE:
% out=op_freqrange(in,ppmmin,ppmmax);
% 
% DESCRIPTION:
% Output only a specified frequency range of the input spectrum.
% 
% INPUTS:
% in         = input data in matlab structure format.
% ppmmin     = minimum extent of frequency range in ppm.
% ppmmax     = maximum extent of frequency range in ppm.
%
% OUTPUTS:
% out        = Output following frequency range selection.

function out=op_freqrange(in,ppmmin,ppmmax,npoints);
if nargin < 4
    npoints = 0;
end
%Calculate Specs using fft
fullspecs=fftshift(fft(in.fids,[],in.dims.t),in.dims.t);

%now take only the specified range of the spectrum
specs=fullspecs(in.ppm>=ppmmin & in.ppm<=ppmmax,:,:);

if npoints ~= 0 && npoints > length(specs)
    specs=fullspecs(:,:,:);
    ppm = in.ppm;

else if npoints ~= 0 && npoints < length(specs)
    ppmmin = ppmmin + (in.ppm(2) -in.ppm(1));
    specs=fullspecs(in.ppm>=ppmmin & in.ppm<=ppmmax,:,:);
    %calculate the ppm scale
    ppm=in.ppm(in.ppm>=ppmmin & in.ppm<=ppmmax);
else
    %calculate the ppm scale
    ppm=in.ppm(in.ppm>=ppmmin & in.ppm<=ppmmax);
    end
end




%convert back to time domain
%if the length of Fids is odd, then you have to do a circshift of one to
%make sure that you don't introduce a small frequency shift into the fids
%vector.
if mod(size(specs,in.dims.t),2)==0
    %disp('Length of vector is even.  Doing normal conversion');
    fids=ifft(fftshift(specs,in.dims.t),[],in.dims.t);
else
    %disp('Length of vector is odd.  Doing circshift by 1');
    fids=ifft(circshift(fftshift(specs,in.dims.t),1),[],in.dims.t);
end

%calculate the size;
sz=size(fids);


%calculate the new spectral width and dwelltime:
dppm=abs(ppm(2)-ppm(1));
ppmrange=abs((ppm(end)-ppm(1)))+dppm;
spectralwidth=ppmrange*in.Bo*42.577;
dwelltime=1/spectralwidth;

%calculate the time scale
t=[0:dwelltime:(sz(1)-1)*dwelltime];



%FILLING IN DATA STRUCTURE
out=in;
out.fids=fids;
out.specs=specs;
out.sz=sz;
out.ppm=ppm;  
out.t=t; 
out.spectralwidth=spectralwidth;
out.dwelltime=dwelltime;

%FILLING IN THE FLAGS
out.flags=in.flags;
out.flags.writtentostruct=1;
out.flags.freqranged=1;