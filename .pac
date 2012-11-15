// http://mediahint.com/default.pac

function FindProxyForURL(url, host) {
	var basic_files = [/.*\.gif/, /.*\.png/, /.*\.jpg/, /.*\.mp3/, /.*\.js/, /.*\.css/, /.*\.mp4/, /.*\.flv/, /.*\.swf/, /hulu\.com\/mozart\//, /.*\.json/, /crossdomain\.xml/];
	for(var i=0;i<basic_files.length;i++){
		if(url.match(basic_files[i])){
			return 'DIRECT';
		}
	}
	var usa = ['hulu.com', 'netflix.com', 'pandora.com'];
	var direct = ['urlcheck.hulu.com', 'r.hulu.com', 'contactus.netflix.com', 'p.hulu.com', 't2.hulu.com', 'assets.hulu.com', 'll.a.hulu.com', 'ads.hulu.com', 'stats.pandora.com', 'blog.netflix.com', 'nordicsblog.netflix.com', 'blog.pandora.com'];
	for(var i=0;i<direct.length;i++){
		if(host.indexOf(direct[i]) > -1){
			return 'DIRECT';
		}
	}
	if(host.match(/audio.*\.pandora\.com/) || host.match(/const.*\.pandora\.com/) || host.match(/mediaserver.*\.pandora\.com/) || host.match(/cont.*\.pandora\.com/)){
		return 'DIRECT';
	}
	for(var i=0;i<usa.length;i++){
		if(host.indexOf(usa[i]) > -1){
			return 'PROXY 50.116.59.63:80';
		}
	}
	return 'DIRECT';
}
