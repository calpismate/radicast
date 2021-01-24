package main

import (
	"fmt"
	"os/exec"
	"regexp"
)

func lookConverterCommand() (string, error) {
	for _, p := range []string{"ffmpeg", "avconv"} {
		cmd, err := exec.LookPath(p)
		if err == nil {
			return cmd, nil
		}
	}
	return "", fmt.Errorf("not found converter cmd such also ffmpeg, avconv.")
}

func newConverterCmd(path, bitrate, output string) (*exec.Cmd, error) {

	switch {
	case regexp.MustCompile("ffmpeg$").MatchString(path):
		return newFfmpegCmd(path, bitrate, output), nil
	case regexp.MustCompile("avconv$").MatchString(path):
		return newAvconvCmd(path, bitrate, output), nil
	}

	return nil, fmt.Errorf("path should be ffmpeg or avconv")
}

func newFfmpegCmd(ffmpeg, bitrate, output string) *exec.Cmd {
	return exec.Command(
		ffmpeg,
		"-y",
		"-i", "-",
		"-vn",
		"-acodec", "libmp3lame",
		"-ar", "44100",
		"-ab", bitrate,
		"-ac", "2",
		output,
	)
}

func hlsFfmpegCmd(ffmpeg, streamURL string, authtoken string, sec string, output string) *exec.Cmd {
	return exec.Command(
		ffmpeg,
		"-loglevel", "error",
		"-fflags", "+discardcorrupt",
		"-headers", `"X-Radiko-Authtoken: `+authtoken+`"`,
		"-i", streamURL,
		"-acodec", "copy",
		"-vn",
		"-bsf:a", "aac_adtstoasc",
		"-y",
		"-t", sec,
		"-movflags", "+faststart",
		output,
	)

}

func newAvconvCmd(avconv, bitrate, output string) *exec.Cmd {
	return exec.Command(
		avconv,
		"-y",
		"-i", "-",
		"-vn",
		"-c:a", "libmp3lame",
		"-ar", "44100",
		"-b:a", bitrate,
		"-ac", "2",
		output,
	)
}
