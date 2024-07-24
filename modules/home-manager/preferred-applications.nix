# This module is based on the Prefered Applications application of Cinnamon
# It allow to set a default application to handle file format
{lib, config, pkgs, ...}:
let
  inherit (lib) mkEnableOption mkOption mkIf mkMerge mkDefault types literalExpression stringLength;
  cfg = config.preferred.applications;
in
{
  options.preferred.applications = {
    enable = mkEnableOption "Preferred Applications";
    
    music = mkOption {
      type = types.str;
      default = null;
      example = literalExpression "\"vlc\"";
      description = "Filename of .desktop representing the default application to use to open music files.";
    };
    
    video = mkOption {
      type = types.str;
      default = null;
      example = literalExpression "\"vlc\"";
      description = "Filename of .desktop representing the default application to use to open video files.";
    };
    
    photos = mkOption {
      type = types.str;
      default = null;
      example = literalExpression "\"nomacs\"";
      description = "Filename of .desktop representing the default application to use to open photos files.";
    };
    
    pdf = mkOption {
      type = types.str;
      default = null;
      example = literalExpression "\"xreader\"";
      description = "Filename of .desktop representing the default application to use to open pdf files.";
    };
    
    sourceCode = mkOption {
      type = types.str;
      default = null;
      example = literalExpression "\"geany\"";
      description = "Filename of .desktop representing the default application to use to open source code files.";
    };
    
    plainText = mkOption {
      type = types.str;
      default = null;
      example = literalExpression "\"xreader\"";
      description = "Filename of .desktop representing the default application to use to open plain text files.";
    };
    
    fileManager = mkOption {
      type = types.str;
      default = null;
      example = literalExpression "\"nemo\"";
      description = "Filename of .desktop representing the default application to use as file manager.";
    };
  };
  
  config = mkMerge([
    (mkIf (cfg.enable && cfg.music != null && (stringLength cfg.music > 0)) {
      xdg.mimeApps = let 
        mimeApps = {
          "audio/3gpp" = [ "${cfg.music}.desktop" ];
          "audio/AMR" = [ "${cfg.music}.desktop" ];
          "audio/AMR-WB" = [ "${cfg.music}.desktop" ];
          "audio/ac3" = [ "${cfg.music}.desktop" ];
          "audio/basic" = [ "${cfg.music}.desktop" ];
          "audio/flac" = [ "${cfg.music}.desktop" ];
          "audio/midi" = [ "${cfg.music}.desktop" ];
          "audio/mp2" = [ "${cfg.music}.desktop" ];
          "audio/mp4" = [ "${cfg.music}.desktop" ];
          "audio/mpeg" = [ "${cfg.music}.desktop" ];
          "audio/mpegurl" = [ "${cfg.music}.desktop" ];
          "audio/ogg" = [ "${cfg.music}.desktop" ];
          "audio/prs.sid" = [ "${cfg.music}.desktop" ];
          "audio/vnd.rn-realaudio" = [ "${cfg.music}.desktop" ];
          "audio/x-aiff" = [ "${cfg.music}.desktop" ];
          "audio/x-ape" = [ "${cfg.music}.desktop" ];
          "audio/x-flac" = [ "${cfg.music}.desktop" ];
          "audio/x-gsm" = [ "${cfg.music}.desktop" ];
          "audio/x-it" = [ "${cfg.music}.desktop" ];
          "audio/x-m4a" = [ "${cfg.music}.desktop" ];
          "audio/x-matroska" = [ "${cfg.music}.desktop" ];
          "audio/x-mod" = [ "${cfg.music}.desktop" ];
          "audio/x-mp3" = [ "${cfg.music}.desktop" ];
          "audio/x-mpeg" = [ "${cfg.music}.desktop" ];
          "audio/x-mpegurl" = [ "${cfg.music}.desktop" ];
          "audio/x-ms-asf" = [ "${cfg.music}.desktop" ];
          "audio/x-ms-asx" = [ "${cfg.music}.desktop" ];
          "audio/x-ms-wax" = [ "${cfg.music}.desktop" ];
          "audio/x-ms-wma" = [ "${cfg.music}.desktop" ];
          "audio/x-musepack" = [ "${cfg.music}.desktop" ];
          "audio/x-pn-aiff" = [ "${cfg.music}.desktop" ];
          "audio/x-pn-au" = [ "${cfg.music}.desktop" ];
          "audio/x-pn-realaudio" = [ "${cfg.music}.desktop" ];
          "audio/x-pn-realaudio-plugin" = [ "${cfg.music}.desktop" ];
          "audio/x-pn-wav" = [ "${cfg.music}.desktop" ];
          "audio/x-pn-windows-acm" = [ "${cfg.music}.desktop" ];
          "audio/x-real-audio" = [ "${cfg.music}.desktop" ];
          "audio/x-realaudio" = [ "${cfg.music}.desktop" ];
          "audio/x-s3m" = [ "${cfg.music}.desktop" ];
          "audio/x-sbc" = [ "${cfg.music}.desktop" ];
          "audio/x-scpls" = [ "${cfg.music}.desktop" ];
          "audio/x-speex" = [ "${cfg.music}.desktop" ];
          "audio/x-stm" = [ "${cfg.music}.desktop" ];
          "audio/x-tta" = [ "${cfg.music}.desktop" ];
          "audio/x-vorbis" = [ "${cfg.music}.desktop" ];
          "audio/x-vorbis+ogg" = [ "${cfg.music}.desktop" ];
          "audio/x-wav" = [ "${cfg.music}.desktop" ];
          "audio/x-wavpack" = [ "${cfg.music}.desktop" ];
          "audio/x-xm" = [ "${cfg.music}.desktop" ];
          "audio/aac" = [ "${cfg.music}.desktop" ];
          "audio/m4a" = [ "${cfg.music}.desktop" ];
          "audio/mp3" = [ "${cfg.music}.desktop" ];
          "audio/mp4a-latm" = [ "${cfg.music}.desktop" ];
          "audio/mpeg3" = [ "${cfg.music}.desktop" ];
          "audio/mpg" = [ "${cfg.music}.desktop" ];
          "audio/vorbis" = [ "${cfg.music}.desktop" ];
          "audio/wav" = [ "${cfg.music}.desktop" ];
          "audio/wave" = [ "${cfg.music}.desktop" ];
          "audio/webm" = [ "${cfg.music}.desktop" ];
          "audio/x-aac" = [ "${cfg.music}.desktop" ];
          "audio/x-mpeg-3" = [ "${cfg.music}.desktop" ];
          "audio/x-mpg" = [ "${cfg.music}.desktop" ];
          "audio/x-ogg" = [ "${cfg.music}.desktop" ];
          "audio/x-oggflac" = [ "${cfg.music}.desktop" ];
        };
      in
      {
        enable = mkDefault true;
        defaultApplications = mimeApps;
        associations.added = mimeApps;
      };
    })
  
    (mkIf (cfg.enable && cfg.video != null && (stringLength cfg.video > 0)) {
      xdg.mimeApps = let 
        mimeApps = {
          "video/3gp" = [ "${cfg.video}.desktop" ];
          "video/3gpp" = [ "${cfg.video}.desktop" ];
          "video/divx" = [ "${cfg.video}.desktop" ];
          "video/dv" = [ "${cfg.video}.desktop" ];
          "video/fli" = [ "${cfg.video}.desktop" ];
          "video/flv" = [ "${cfg.video}.desktop" ];
          "video/mp2t" = [ "${cfg.video}.desktop" ];
          "video/mp4" = [ "${cfg.video}.desktop" ];
          "video/mp4v-es" = [ "${cfg.video}.desktop" ];
          "video/mpeg" = [ "${cfg.video}.desktop" ];
          "video/msvideo" = [ "${cfg.video}.desktop" ];
          "video/ogg" = [ "${cfg.video}.desktop" ];
          "video/quicktime" = [ "${cfg.video}.desktop" ];
          "video/vivo" = [ "${cfg.video}.desktop" ];
          "video/vnd.divx" = [ "${cfg.video}.desktop" ];
          "video/vnd.mpegurl" = [ "${cfg.video}.desktop" ];
          "video/vnd.rn-realvideo" = [ "${cfg.video}.desktop" ];
          "video/vnd.vivo" = [ "${cfg.video}.desktop" ];
          "video/webm" = [ "${cfg.video}.desktop" ];
          "video/x-anim" = [ "${cfg.video}.desktop" ];
          "video/x-avi" = [ "${cfg.video}.desktop" ];
          "video/x-flc" = [ "${cfg.video}.desktop" ];
          "video/x-fli" = [ "${cfg.video}.desktop" ];
          "video/x-flic" = [ "${cfg.video}.desktop" ];
          "video/x-flv" = [ "${cfg.video}.desktop" ];
          "video/x-m4v" = [ "${cfg.video}.desktop" ];
          "video/x-matroska" = [ "${cfg.video}.desktop" ];
          "video/x-mpeg" = [ "${cfg.video}.desktop" ];
          "video/x-mpeg2" = [ "${cfg.video}.desktop" ];
          "video/x-ms-asf" = [ "${cfg.video}.desktop" ];
          "video/x-ms-asx" = [ "${cfg.video}.desktop" ];
          "video/x-ms-wm" = [ "${cfg.video}.desktop" ];
          "video/x-ms-wmv" = [ "${cfg.video}.desktop" ];
          "video/x-ms-wmx" = [ "${cfg.video}.desktop" ];
          "video/x-ms-wvx" = [ "${cfg.video}.desktop" ];
          "video/x-msvideo" = [ "${cfg.video}.desktop" ];
          "video/x-nsv" = [ "${cfg.video}.desktop" ];
          "video/x-ogm+ogg" = [ "${cfg.video}.desktop" ];
          "video/x-theora+ogg" = [ "${cfg.video}.desktop" ];
          "video/x-${cfg.video}-stream" = [ "${cfg.video}.desktop" ];
          "video/x-mng" = [ "${cfg.video}.desktop" ];
          "video/x-ms-afs" = [ "${cfg.video}.desktop" ];
          "video/x-ms-wvxvideo" = [ "${cfg.video}.desktop" ];
          "video/x-theora" = [ "${cfg.video}.desktop" ];
        };
      in
      {
        enable = mkDefault true;
        defaultApplications = mimeApps;
        associations.added = mimeApps;
      };
    })
    
    (mkIf (cfg.enable && cfg.photos != null && (stringLength cfg.photos > 0)) {
      xdg.mimeApps = let 
        mimeApps = {
          "image/avif" = [ "${cfg.photos}.desktop" ];
          "image/bmp" = [ "${cfg.photos}.desktop" ];
          "image/gif" = [ "${cfg.photos}.desktop" ];
          "image/heic" = [ "${cfg.photos}.desktop" ];
          "image/heif" = [ "${cfg.photos}.desktop" ];
          "image/jpeg" = [ "${cfg.photos}.desktop" ];
          "image/jxl" = [ "${cfg.photos}.desktop" ];
          "image/png" = [ "${cfg.photos}.desktop" ];
          "image/tiff" = [ "${cfg.photos}.desktop" ];
          "image/webp" = [ "${cfg.photos}.desktop" ];
          "image/x-eps" = [ "${cfg.photos}.desktop" ];
          "image/x-ico" = [ "${cfg.photos}.desktop" ];
          "image/x-portable-bitmap" = [ "${cfg.photos}.desktop" ];
          "image/x-portable-graymap" = [ "${cfg.photos}.desktop" ];
          "image/x-portable-pixmap" = [ "${cfg.photos}.desktop" ];
          "image/x-xbitmap" = [ "${cfg.photos}.desktop" ];
          "image/x-xpixmap" = [ "${cfg.photos}.desktop" ];
        };
      in
      {
        enable = mkDefault true;
        defaultApplications = mimeApps;
        associations.added = mimeApps;
      };
    })
    
    (mkIf (cfg.enable && cfg.pdf != null && (stringLength cfg.pdf > 0)) {
      xdg.mimeApps = let 
        mimeApps = {
          "application/pdf" = [ "${cfg.pdf}.desktop" ];
        };
      in
      {
        enable = mkDefault true;
        defaultApplications = mimeApps;
        associations.added = mimeApps;
      };
    })
    
    (mkIf (cfg.enable && cfg.sourceCode != null && (stringLength cfg.sourceCode > 0)) {
      xdg.mimeApps = let 
        mimeApps = {
          "text/x-python" = [ "${cfg.sourceCode}.desktop" ];
          "application/javascript" = [ "${cfg.sourceCode}.desktop" ];
          "application/x-httpd-php3" = [ "${cfg.sourceCode}.desktop" ];
          "application/x-httpd-php4" = [ "${cfg.sourceCode}.desktop" ];
          "application/x-httpd-php5" = [ "${cfg.sourceCode}.desktop" ];
          "application/x-m4" = [ "${cfg.sourceCode}.desktop" ];
          "application/x-php" = [ "${cfg.sourceCode}.desktop" ];
          "application/x-ruby" = [ "${cfg.sourceCode}.desktop" ];
          "application/x-shellscript" = [ "${cfg.sourceCode}.desktop" ];
          "application/xml" = [ "${cfg.sourceCode}.desktop" ];
          "text/css" = [ "${cfg.sourceCode}.desktop" ];
          "text/turtle" = [ "${cfg.sourceCode}.desktop" ];
          "text/x-c++hdr" = [ "${cfg.sourceCode}.desktop" ];
          "text/x-c++src" = [ "${cfg.sourceCode}.desktop" ];
          "text/x-chdr" = [ "${cfg.sourceCode}.desktop" ];
          "text/x-csharp" = [ "${cfg.sourceCode}.desktop" ];
          "text/x-csrc" = [ "${cfg.sourceCode}.desktop" ];
          "text/x-diff" = [ "${cfg.sourceCode}.desktop" ];
          "text/x-dsrc" = [ "${cfg.sourceCode}.desktop" ];
          "text/x-fortran" = [ "${cfg.sourceCode}.desktop" ];
          "text/x-java" = [ "${cfg.sourceCode}.desktop" ];
          "text/x-makefile" = [ "${cfg.sourceCode}.desktop" ];
          "text/x-pascal" = [ "${cfg.sourceCode}.desktop" ];
          "text/x-perl" = [ "${cfg.sourceCode}.desktop" ];
          "text/x-sql" = [ "${cfg.sourceCode}.desktop" ];
          "text/x-vb" = [ "${cfg.sourceCode}.desktop" ];
          "text/yaml" = [ "${cfg.sourceCode}.desktop" ];
        };
      in
      {
        enable = mkDefault true;
        defaultApplications = mimeApps;
        associations.added = mimeApps;
      };
    })
    
    (mkIf (cfg.enable && cfg.plainText != null && (stringLength cfg.plainText > 0)) {
      xdg.mimeApps = let 
        mimeApps = {
          "text/plain" = [ "${cfg.plainText}.desktop" ];
        };
      in
      {
        enable = mkDefault true;
        defaultApplications = mimeApps;
        associations.added = mimeApps;
      };
    })
    
    (mkIf (cfg.enable && cfg.fileManager != null && (stringLength cfg.fileManager > 0)) {
      xdg.mimeApps = let 
        mimeApps = {
          "inode/directory" = [ "${cfg.fileManager}.desktop" ];
        };
      in
      {
        enable = mkDefault true;
        defaultApplications = mimeApps;
        associations.added = mimeApps;
      };
    })
  ]);
}