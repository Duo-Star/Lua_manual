--如何让设备发出正弦波形声音: AudioTrack ，修改的网上java源码，逻辑可能有点奇怪，后期会优化
--运行时请降低设备音量，不要被吓到😉
--用这个或许可以写一个电子钢琴()
require "import"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
local AudioTrack = luajava.bindClass "android.media.AudioTrack"
local AudioFormat = luajava.bindClass "android.media.AudioFormat"
local AudioManager = luajava.bindClass "android.media.AudioManager"
duration = 3
sampleRate = 5000
numSamples = duration * sampleRate
freqOfTone = 100
sample={}
generatedSnd={}
for i=1,numSamples do
  sample[i] = Math.sin(2 * Math.PI * i / (sampleRate/freqOfTone));
end
for dVal =1, #sample do
  generatedSnd[#generatedSnd+1] = dVal * 10000
end
audioTrack=AudioTrack(AudioManager.STREAM_MUSIC,
sampleRate, AudioFormat.CHANNEL_CONFIGURATION_MONO,
AudioFormat.ENCODING_PCM_16BIT, numSamples,
AudioTrack.MODE_STATIC);
audioTrack.write(generatedSnd, 0, #generatedSnd);
audioTrack.play()