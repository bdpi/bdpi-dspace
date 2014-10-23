package read.rss.main;

import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.InetSocketAddress;
import java.net.Proxy;
import java.net.URL;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import read.rss.entity.Noticia;

import com.sun.syndication.feed.synd.SyndContent;
import com.sun.syndication.feed.synd.SyndEntry;
import com.sun.syndication.feed.synd.SyndFeed;
import com.sun.syndication.io.SyndFeedInput;

public class Main {
	
	public static void main(String[] args) {
		try {
			String urlstring = "http://www5.usp.br/feed/?category=cultura";
			
			Proxy proxy = new Proxy(Proxy.Type.HTTP, new InetSocketAddress("proxy.saude.gov", 80));
			InputStream is = new URL(urlstring).openConnection(proxy).getInputStream();
			
			SyndFeedInput input = new SyndFeedInput();
			SyndFeed feed = (SyndFeed) input.build(new InputStreamReader(is, Charset.forName("UTF-8")));

			List<Noticia> listaNoticia = new ArrayList<Noticia>();
			Noticia noticia = null;

			Iterator<?> entries = feed.getEntries().iterator();
			while (entries.hasNext() && listaNoticia.size() < 5) {
				noticia = new Noticia();

				SyndEntry entry = (SyndEntry) entries.next();

				noticia.setTitulo(entry.getTitle());
				noticia.setDataPublicacao(entry.getPublishedDate());
				noticia.setLink(entry.getLink());

				if (entry.getDescription() != null) {
					noticia.setDescricao(entry.getDescription().getValue());
				}

				if (entry.getContents().size() > 0) {
					@SuppressWarnings("unused")
					SyndContent content = (SyndContent) entry.getContents().get(0);
//					System.out.println(content.getValue());
				}

				listaNoticia.add(noticia);
			}
			
			for(Noticia n : listaNoticia) {
				System.out.println("Título: " + n.getTitulo());
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
}