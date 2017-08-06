//
// SoundTouchDLL.h header binding for the Free Pascal Compiler aka FPC
//
// Binaries and demos available at http://www.djmaster.com/
//

//////////////////////////////////////////////////////////////////////////////
///
/// SoundTouch DLL wrapper - wraps SoundTouch routines into a Dynamic Load 
/// Library interface.
///
/// Author        : Copyright (c) Olli Parviainen
/// Author e-mail : oparviai 'at' iki.fi
/// SoundTouch WWW: http://www.surina.net/soundtouch
///
////////////////////////////////////////////////////////////////////////////////
//
// $Id: SoundTouchDLL.h 248 2017-03-05 16:36:35Z oparviai $
//
////////////////////////////////////////////////////////////////////////////////
//
// License :
//
//  SoundTouch audio processing library
//  Copyright (c) Olli Parviainen
//
//  This library is free software; you can redistribute it and/or
//  modify it under the terms of the GNU Lesser General Public
//  License as published by the Free Software Foundation; either
//  version 2.1 of the License, or (at your option) any later version.
//
//  This library is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
//  Lesser General Public License for more details.
//
//  You should have received a copy of the GNU Lesser General Public
//  License along with this library; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
//
////////////////////////////////////////////////////////////////////////////////

unit soundtouch;

interface

uses
  ctypes;

const
  LIB_SOUNDTOUCH = 'SoundTouchDLL.dll';
  SOUNDTOUCH_VERSION = '2.0.0';

type
  ST_HANDLE = pointer;

/// Create a new instance of SoundTouch processor.
function soundtouch_createInstance(): ST_HANDLE; cdecl; external LIB_SOUNDTOUCH;

/// Destroys a SoundTouch processor instance.
procedure soundtouch_destroyInstance(h: ST_HANDLE); cdecl; external LIB_SOUNDTOUCH;

/// Get SoundTouch library version string
function soundtouch_getVersionString(): pchar; cdecl; external LIB_SOUNDTOUCH;

/// Get SoundTouch library version string - alternative function for 
/// environments that can't properly handle character string as return value
procedure soundtouch_getVersionString2(VersionString: pchar; bufferSize: cint); cdecl; external LIB_SOUNDTOUCH;

/// Get SoundTouch library version Id
function soundtouch_getVersionId(): cuint; cdecl; external LIB_SOUNDTOUCH;

/// Sets new rate control value. Normal rate = 1.0, smaller values
/// represent slower rate, larger faster rates.
procedure soundtouch_setRate(h: ST_HANDLE; newRate: cfloat); cdecl; external LIB_SOUNDTOUCH;

/// Sets new tempo control value. Normal tempo = 1.0, smaller values
/// represent slower tempo, larger faster tempo.
procedure soundtouch_setTempo(h: ST_HANDLE; newTempo: cfloat); cdecl; external LIB_SOUNDTOUCH;

/// Sets new rate control value as a difference in percents compared
/// to the original rate (-50 .. +100 %);
procedure soundtouch_setRateChange(h: ST_HANDLE; newRate: cfloat); cdecl; external LIB_SOUNDTOUCH;

/// Sets new tempo control value as a difference in percents compared
/// to the original tempo (-50 .. +100 %);
procedure soundtouch_setTempoChange(h: ST_HANDLE; newTempo: cfloat); cdecl; external LIB_SOUNDTOUCH;

/// Sets new pitch control value. Original pitch = 1.0, smaller values
/// represent lower pitches, larger values higher pitch.
procedure soundtouch_setPitch(h: ST_HANDLE; newPitch: cfloat); cdecl; external LIB_SOUNDTOUCH;

/// Sets pitch change in octaves compared to the original pitch  
/// (-1.00 .. +1.00);
procedure soundtouch_setPitchOctaves(h: ST_HANDLE; newPitch: cfloat); cdecl; external LIB_SOUNDTOUCH;

/// Sets pitch change in semi-tones compared to the original pitch
/// (-12 .. +12);
procedure soundtouch_setPitchSemiTones(h: ST_HANDLE; newPitch: cfloat); cdecl; external LIB_SOUNDTOUCH;

/// Sets the number of channels, 1 = mono, 2 = stereo, n = multichannel
procedure soundtouch_setChannels(h: ST_HANDLE; numChannels: cuint); cdecl; external LIB_SOUNDTOUCH;

/// Sets sample rate.
procedure soundtouch_setSampleRate(h: ST_HANDLE; srate: cuint); cdecl; external LIB_SOUNDTOUCH;

/// Flushes the last samples from the processing pipeline to the output.
/// Clears also the internal processing buffers.
//
/// Note: This function is meant for extracting the last samples of a sound
/// stream. This function may introduce additional blank samples in the end
/// of the sound stream, and thus it's not recommended to call this function
/// in the middle of a sound stream.
procedure soundtouch_flush(h: ST_HANDLE); cdecl; external LIB_SOUNDTOUCH;

/// Adds 'numSamples' pcs of samples from the 'samples' memory position into
/// the input of the object. Notice that sample rate _has_to_ be set before
/// calling this function, otherwise throws a runtime_error exception.
procedure soundtouch_putSamples(h: ST_HANDLE; const samples: pcfloat; numSamples: cuint); cdecl; external LIB_SOUNDTOUCH;

/// int16 version of soundtouch_putSamples(): This accept int16 (short) sample data
/// and internally converts it to float format before processing
procedure soundtouch_putSamples_i16(h: ST_HANDLE; const samples: pcshort; numSamples: cuint); cdecl; external LIB_SOUNDTOUCH;

/// Clears all the samples in the object's output and internal processing
/// buffers.
procedure soundtouch_clear(h: ST_HANDLE); cdecl; external LIB_SOUNDTOUCH;

/// Changes a setting controlling the processing system behaviour. See the
/// 'SETTING_...' defines for available setting ID's.
/// 
/// \return 'nonzero' if the setting was succesfully changed, otherwise zero
function soundtouch_setSetting(h: ST_HANDLE; settingId: cint; value: cint): cint; cdecl; external LIB_SOUNDTOUCH;

/// Reads a setting controlling the processing system behaviour. See the
/// 'SETTING_...' defines for available setting ID's.
///
/// \return the setting value.
function soundtouch_getSetting(h: ST_HANDLE; settingId: cint): cint; cdecl; external LIB_SOUNDTOUCH;

/// Returns number of samples currently unprocessed.
function soundtouch_numUnprocessedSamples(h: ST_HANDLE): cuint; cdecl; external LIB_SOUNDTOUCH;

/// Adjusts book-keeping so that given number of samples are removed from beginning of the 
/// sample buffer without copying them anywhere. 
///
/// Used to reduce the number of samples in the buffer when accessing the sample buffer directly
/// with 'ptrBegin' function.
function soundtouch_receiveSamples(h: ST_HANDLE; outBuffer: pcfloat; maxSamples: cuint): cuint; cdecl; external LIB_SOUNDTOUCH;

/// int16 version of soundtouch_receiveSamples(): This converts internal float samples
/// into int16 (short) return data type
function soundtouch_receiveSamples_i16(h: ST_HANDLE; outBuffer: pcshort; maxSamples: cuint): cuint; cdecl; external LIB_SOUNDTOUCH;

/// Returns number of samples currently available.
function soundtouch_numSamples(h: ST_HANDLE): cuint; cdecl; external LIB_SOUNDTOUCH;

/// Returns nonzero if there aren't any samples available for outputting.
function soundtouch_isEmpty(h: ST_HANDLE): cint; cdecl; external LIB_SOUNDTOUCH;


implementation


end.

