//
//  MockPosts.swift
//  MacMagazineTests
//
//  Created by Cassio Rossi on 16/12/2021.
//  Copyright © 2021 MacMagazine. All rights reserved.
//

import Foundation

struct MockPosts {

    let example = """
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0"
    xmlns:content="http://purl.org/rss/1.0/modules/content/"
    xmlns:wfw="http://wellformedweb.org/CommentAPI/"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:atom="http://www.w3.org/2005/Atom"
    xmlns:sy="http://purl.org/rss/1.0/modules/syndication/"
    xmlns:slash="http://purl.org/rss/1.0/modules/slash/"
    xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd"
xmlns:podcast="https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md"
xmlns:rawvoice="http://www.rawvoice.com/rawvoiceRssModule/"
xmlns:googleplay="http://www.google.com/schemas/play-podcasts/1.0"

    xmlns:georss="http://www.georss.org/georss"
    xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#"
    >
    <channel>
        <title>MacMagazine</title>
        <atom:link href="https://macmagazine.com.br/feed/?paged=0" rel="self" type="application/rss+xml" />
        <link>https://macmagazine.com.br</link>
        <description>O melhor pedaço da Maçã.</description>
        <lastBuildDate>Thu, 16 Dec 2021 15:04:05 +0000</lastBuildDate>
        <language>pt-BR</language>
        <sy:updatePeriod>
    hourly    </sy:updatePeriod>
        <sy:updateFrequency>
    1    </sy:updateFrequency>
        <generator>https://wordpress.org/?v=5.8.2</generator>
        <image>
            <url>https://macmagazine.com.br/wp-content/uploads/2018/02/mm-300x300.png</url>
            <title>MacMagazine</title>
            <link>https://macmagazine.com.br</link>
            <width>32</width>
            <height>32</height>
        </image>
        <!-- podcast_generator="Blubrry PowerPress/8.7.8" mode="advanced" feedslug="feed" Blubrry PowerPress Podcasting plugin for WordPress (https://www.blubrry.com/powerpress/) -->
        <atom:link rel="hub" href="https://pubsubhubbub.appspot.com/" />
        <itunes:summary>Blog sobre assuntos relacionados principalmente ao mundo Macintosh (Apple e afins), mas que também aborda tudo que vier à tona com relação a internet, tecnologia, novidades em informática, gadgets, eletrônicos etc. Inclusive pode falar sobre qualquer outra coisa, que não tem problema: basta que seja interessante. ;-)</itunes:summary>
        <itunes:author>MacMagazine.com.br</itunes:author>
        <itunes:explicit>clean</itunes:explicit>
        <itunes:image href="https://macmagazine.com.br/wp-content/uploads/powerpress/capa.png" />
        <itunes:type>episodic</itunes:type>
        <itunes:owner>
            <itunes:name>MacMagazine.com.br</itunes:name>
            <itunes:email>contato@macmagazine.com.br</itunes:email>
        </itunes:owner>
        <managingEditor>contato@macmagazine.com.br (MacMagazine.com.br)</managingEditor>
        <copyright>2002-2021 &#xA9; MacMagazine.com.br</copyright>
        <itunes:subtitle>Confira mais um episódio do podcast MacMagazine no Ar!</itunes:subtitle>
        <itunes:category text="News">
            <itunes:category text="Tech News" /></itunes:category>
        <googleplay:category text="News &amp; Politics"/>
        <rawvoice:rating>TV-14</rawvoice:rating>
        <rawvoice:location>Brasil</rawvoice:location>
        <podcast:location>Brasil</podcast:location>
        <rawvoice:frequency>Semanal</rawvoice:frequency>
        <rawvoice:subscribe feed="https://macmagazine.com.br/feed/?paged=0" itunes="https://podcasts.apple.com/br/podcast/macmagazine-no-ar/id547137017" spotify="https://open.spotify.com/show/52IrqJ0ZwPVp0kKXaOWnLP" deezer="https://www.deezer.com/br/show/13129"></rawvoice:subscribe>
        <site xmlns="com-wordpress:feed-additions:1">154826423</site>
        <item>
            <title>Pixelmator Photo chega ao iPhone</title>
            <link>https://macmagazine.com.br/post/2021/12/16/pixelmator-photo-chega-ao-iphone/</link>
            <comments>https://macmagazine.com.br/post/2021/12/16/pixelmator-photo-chega-ao-iphone/#respond</comments>
            <dc:creator>
                <![CDATA[Rafael Fischmann]]>
            </dc:creator>
            <pubDate>Thu, 16 Dec 2021 15:00:00 +0000</pubDate>
            <category>
                <![CDATA[Dicas]]>
            </category>
            <category>
                <![CDATA[Gadgets]]>
            </category>
            <category>
                <![CDATA[Software]]>
            </category>
            <category>
                <![CDATA[ajustes]]>
            </category>
            <category>
                <![CDATA[aplicativo]]>
            </category>
            <category>
                <![CDATA[app]]>
            </category>
            <category>
                <![CDATA[App Store]]>
            </category>
            <category>
                <![CDATA[aprendizado de máquina]]>
            </category>
            <category>
                <![CDATA[artefatos]]>
            </category>
            <category>
                <![CDATA[atualização]]>
            </category>
            <category>
                <![CDATA[cores]]>
            </category>
            <category>
                <![CDATA[crop]]>
            </category>
            <category>
                <![CDATA[denoise]]>
            </category>
            <category>
                <![CDATA[edição]]>
            </category>
            <category>
                <![CDATA[editor]]>
            </category>
            <category>
                <![CDATA[foto]]>
            </category>
            <category>
                <![CDATA[fotografia]]>
            </category>
            <category>
                <![CDATA[fotos]]>
            </category>
            <category>
                <![CDATA[imagem]]>
            </category>
            <category>
                <![CDATA[imagens]]>
            </category>
            <category>
                <![CDATA[iPhone]]>
            </category>
            <category>
                <![CDATA[machine learning]]>
            </category>
            <category>
                <![CDATA[não-destrutiva]]>
            </category>
            <category>
                <![CDATA[Pixelmator]]>
            </category>
            <category>
                <![CDATA[Pixelmator Photo]]>
            </category>
            <category>
                <![CDATA[ruídos]]>
            </category>
            <category>
                <![CDATA[update]]>
            </category>
            <guid isPermaLink="false">https://macmagazine.com.br/?p=841702</guid>
            <description>
                <![CDATA[Lançado originalmente em abril de 2019 para iPad, o Pixelmator Photo acaba de chegar hoje à sua versão&#8230;]]>
            </description>
            <content:encoded>
                <![CDATA[<img width="1024" height="1024" src="https://macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-Icon.png" class="webfeedsFeaturedVisual wp-post-image" alt="" style="display: block; margin: auto; margin-bottom: 5px;max-width: 100%;" link_thumbnail="" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-Icon.png 1024w, https://macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-Icon-600x600.png 600w, https://macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-Icon-300x300.png 300w, https://macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-Icon-80x80.png 80w, https://macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-Icon-110x110.png 110w, https://macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-Icon-380x380.png 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-Icon-800x800.png 800w" sizes="(max-width: 1024px) 100vw, 1024px" /><p><a href="https://macmagazine.com.br/post/2019/04/09/saiu-o-pixelmator-photo-avancado-editor-de-fotos-para-ipad/">Lançado originalmente em abril de 2019</a> para iPad, o<strong>Pixelmator Photo</strong> acaba de chegar hoje à sua versão 2.0 e agora roda também em iPhones.<img src="https://s.w.org/images/core/emoji/13.1.0/72x72/1f38a.png" alt="🎊" class="wp-smiley" style="height: 1em; max-height: 1em;" /></p><p>Eu, que não tenho mais iPad há alguns anos, esperava por isso há bastante tempo. Tenho um ou outro editor de fotos no meu iPhone, mas sempre sonhei com o Pixelmator — afinal, também uso hoje em dia o <a href="https://macmagazine.com.br/sobre/pixelmator-pro/">Pixelmator Pro</a> como meu editor primário no Mac.</p><div class="wp-block-jetpack-tiled-gallery aligncenter is-style-rectangular"><div class="tiled-gallery__gallery"><div class="tiled-gallery__row"><div class="tiled-gallery__col" style="flex-basis:19.76240%"><figure class="tiled-gallery__item"><a href="https://i2.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-1-%E2%80%93-Lead-Image-623x1260.png?ssl=1"><img srcset="https://i2.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-1-%E2%80%93-Lead-Image-623x1260.png?strip=info&#038;w=600&#038;ssl=1 600w,https://i2.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-1-%E2%80%93-Lead-Image-623x1260.png?strip=info&#038;w=900&#038;ssl=1 900w,https://i2.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-1-%E2%80%93-Lead-Image-623x1260.png?strip=info&#038;w=1200&#038;ssl=1 1200w,https://i2.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-1-%E2%80%93-Lead-Image-623x1260.png?strip=info&#038;w=1315&#038;ssl=1 1315w" alt="" data-height="2659" data-id="841707" data-link="https://macmagazine.com.br/?attachment_id=841707" data-url="https://macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-–-1-–-Lead-Image-623x1260.png" data-width="1315" src="https://i2.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-1-%E2%80%93-Lead-Image-623x1260.png?ssl=1" data-amp-layout="responsive"/></a></figure></div><div class="tiled-gallery__col" style="flex-basis:80.23760%"><figure class="tiled-gallery__item"><a href="https://i0.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-5-%E2%80%93-Landscape-Editing-1260x623.png?ssl=1"><img srcset="https://i0.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-5-%E2%80%93-Landscape-Editing-1260x623.png?strip=info&#038;w=600&#038;ssl=1 600w,https://i0.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-5-%E2%80%93-Landscape-Editing-1260x623.png?strip=info&#038;w=900&#038;ssl=1 900w,https://i0.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-5-%E2%80%93-Landscape-Editing-1260x623.png?strip=info&#038;w=1200&#038;ssl=1 1200w,https://i0.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-5-%E2%80%93-Landscape-Editing-1260x623.png?strip=info&#038;w=1500&#038;ssl=1 1500w,https://i0.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-5-%E2%80%93-Landscape-Editing-1260x623.png?strip=info&#038;w=1800&#038;ssl=1 1800w,https://i0.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-5-%E2%80%93-Landscape-Editing-1260x623.png?strip=info&#038;w=2000&#038;ssl=1 2000w" alt="" data-height="1315" data-id="841713" data-link="https://macmagazine.com.br/?attachment_id=841713" data-url="https://macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-–-5-–-Landscape-Editing-1260x623.png" data-width="2659" src="https://i0.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-5-%E2%80%93-Landscape-Editing-1260x623.png?ssl=1" data-amp-layout="responsive"/></a></figure></div></div><div class="tiled-gallery__row"><div class="tiled-gallery__col" style="flex-basis:25.00000%"><figure class="tiled-gallery__item"><a href="https://i1.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-2-%E2%80%93-Machine-Learning-623x1260.png?ssl=1"><img srcset="https://i1.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-2-%E2%80%93-Machine-Learning-623x1260.png?strip=info&#038;w=600&#038;ssl=1 600w,https://i1.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-2-%E2%80%93-Machine-Learning-623x1260.png?strip=info&#038;w=900&#038;ssl=1 900w,https://i1.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-2-%E2%80%93-Machine-Learning-623x1260.png?strip=info&#038;w=1200&#038;ssl=1 1200w,https://i1.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-2-%E2%80%93-Machine-Learning-623x1260.png?strip=info&#038;w=1315&#038;ssl=1 1315w" alt="" data-height="2659" data-id="841709" data-link="https://macmagazine.com.br/?attachment_id=841709" data-url="https://macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-–-2-–-Machine-Learning-623x1260.png" data-width="1315" src="https://i1.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-2-%E2%80%93-Machine-Learning-623x1260.png?ssl=1" data-amp-layout="responsive"/></a></figure></div><div class="tiled-gallery__col" style="flex-basis:25.00000%"><figure class="tiled-gallery__item"><a href="https://i2.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-3-%E2%80%93-Filmstrip-623x1260.png?ssl=1"><img srcset="https://i2.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-3-%E2%80%93-Filmstrip-623x1260.png?strip=info&#038;w=600&#038;ssl=1 600w,https://i2.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-3-%E2%80%93-Filmstrip-623x1260.png?strip=info&#038;w=900&#038;ssl=1 900w,https://i2.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-3-%E2%80%93-Filmstrip-623x1260.png?strip=info&#038;w=1200&#038;ssl=1 1200w,https://i2.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-3-%E2%80%93-Filmstrip-623x1260.png?strip=info&#038;w=1315&#038;ssl=1 1315w" alt="" data-height="2659" data-id="841710" data-link="https://macmagazine.com.br/?attachment_id=841710" data-url="https://macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-–-3-–-Filmstrip-623x1260.png" data-width="1315" src="https://i2.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-3-%E2%80%93-Filmstrip-623x1260.png?ssl=1" data-amp-layout="responsive"/></a></figure></div><div class="tiled-gallery__col" style="flex-basis:25.00000%"><figure class="tiled-gallery__item"><a href="https://i1.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-4-%E2%80%93-Browser-623x1260.png?ssl=1"><img srcset="https://i1.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-4-%E2%80%93-Browser-623x1260.png?strip=info&#038;w=600&#038;ssl=1 600w,https://i1.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-4-%E2%80%93-Browser-623x1260.png?strip=info&#038;w=900&#038;ssl=1 900w,https://i1.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-4-%E2%80%93-Browser-623x1260.png?strip=info&#038;w=1200&#038;ssl=1 1200w,https://i1.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-4-%E2%80%93-Browser-623x1260.png?strip=info&#038;w=1315&#038;ssl=1 1315w" alt="" data-height="2659" data-id="841712" data-link="https://macmagazine.com.br/?attachment_id=841712" data-url="https://macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-–-4-–-Browser-623x1260.png" data-width="1315" src="https://i1.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-4-%E2%80%93-Browser-623x1260.png?ssl=1" data-amp-layout="responsive"/></a></figure></div><div class="tiled-gallery__col" style="flex-basis:25.00000%"><figure class="tiled-gallery__item"><a href="https://i0.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-6-%E2%80%93-Crop-Tool-623x1260.png?ssl=1"><img srcset="https://i0.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-6-%E2%80%93-Crop-Tool-623x1260.png?strip=info&#038;w=600&#038;ssl=1 600w,https://i0.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-6-%E2%80%93-Crop-Tool-623x1260.png?strip=info&#038;w=900&#038;ssl=1 900w,https://i0.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-6-%E2%80%93-Crop-Tool-623x1260.png?strip=info&#038;w=1200&#038;ssl=1 1200w,https://i0.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-6-%E2%80%93-Crop-Tool-623x1260.png?strip=info&#038;w=1315&#038;ssl=1 1315w" alt="" data-height="2659" data-id="841714" data-link="https://macmagazine.com.br/?attachment_id=841714" data-url="https://macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-–-6-–-Crop-Tool-623x1260.png" data-width="1315" src="https://i0.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-6-%E2%80%93-Crop-Tool-623x1260.png?ssl=1" data-amp-layout="responsive"/></a></figure></div></div></div></div><p>O Pixelmator Photo para iPhone traz toda a experiência de edição conhecida do Pixelmator para as telinhas (nem tanto, vai… mas comparadas com as de iPads e Macs até vai <img src="https://s.w.org/images/core/emoji/13.1.0/72x72/1f61c.png" alt="😜" class="wp-smiley" style="height: 1em; max-height: 1em;" />) dos smartphones, adicionando um browser redesenhado para fotos e a possibilidade de remover ruídos/artefatos por meio de aprendizado de máquina.</p><p>Todos os ajustes feitos pelo Pixelmator Photo são não-destrutivos, incluindo a remoção de objetos com uma simples seleção com os dedos. Ele também inclui os já conhecidos algoritmos de ML do Pixelmator para aprimorar imagens automaticamente, <a href="https://macmagazine.com.br/post/2020/09/15/pixelmator-photo-para-ipad-ganha-recurso-ml-super-resolution/">aumentar resolução</a>, etc. E já é compatível com mais de 600 formatos de imagens RAW,<a href="https://macmagazine.com.br/post/2020/12/10/pixelmator-photo-agora-suporta-proraw-dos-iphones-12-pro/">incluindo o Apple ProRAW</a>.</p><p>Por tempo limitado, em promoção de lançamento, o Pixelmator Photo <a href="https://apps.apple.com/br/app/pixelmator-photo/id1444636541">está com <strong>50% de desconto na App Store</strong></a>. Essa versão para iPhone é uma atualização do app já existente, ou seja, ele está se tornando universal; quem já o tinha no iPad pode, agora, instalá-lo em seus iPhones sem pagar nada mais por isso.</p><hr /><div class="appbox"><div class="appbox-icon"><a href="https://apps.apple.com/br/app/pixelmator-photo/id1444636541" target="_blank"><img class="appbox-iconiOS" alt="&Iacute;cone do app Pixelmator Photo" src="https://is2-ssl.mzstatic.com/image/thumb/Purple116/v4/9d/86/24/9d862475-719d-75d5-2fee-4a4091416bcf/AppIcon-0-1x_U007emarketing-0-7-0-sRGB-85-220.png/256x256bb.png" /></a></div><div class="appbox-details"><span class="appbox-name"><a href="https://apps.apple.com/br/app/pixelmator-photo/id1444636541" target="_blank">Pixelmator Photo</a></span><span class="appbox-de">de <strong><a href="https://www.pixelmator.com/photo/" target="_blank" class="no_icon" rel="nofollow">Pixelmator Team</a></strong></span><div class="appbox-devices"><img src="https://macmagazine.com.br/wp-content/uploads/2015/11/devices_ipad.png" alt="Compat&iacute;vel com iPads" title="Compat&iacute;vel com iPads" class="appbox-devicesiPad" /><img src="https://macmagazine.com.br/wp-content/uploads/2015/11/devices_iphone.png" alt="Compat&iacute;vel com iPhones" title="Compat&iacute;vel com iPhones" class="appbox-devicesiPhone" /></div><div class="appbox-info">Vers&atilde;o <strong>2.0</strong> (193.5 MB)<br />
                    Requer o <strong>iOS 14.0</strong> ou superior</div></div><div class="appbox-badge"><span class="appbox-price">R$ 22,90 <b class="appbox-oldprice">R$ 44.90</b></span><span><a href="https://apps.apple.com/br/app/pixelmator-photo/id1444636541" target="_blank"><img alt="Badge - Baixar na App Store" src="https://macmagazine.com.br/wp-content/uploads/2017/11/22-badge_appstore.png" class="badgeInvert" /></a></span><span class="appbox-QRcode"><a href="javascript:void(0);" title="C&oacute;digo QR - Pixelmator Photo" onclick="javascript:abrirQR('https://chart.googleapis.com/chart?chs=400x400&cht=qr&chl=https%3A%2F%2Fapps.apple.com%2Fbr%2Fapp%2Fpixelmator-photo%2Fid1444636541&chld=L|0');return false;"><img alt="C&oacute;digo QR" src="https://macmagazine.com.br/wp-content/themes/newsblock-child/images/qr.png" /></a><a href="javascript:void(0);" title="C&oacute;digo QR - Pixelmator Photo" onclick="javascript:abrirQR('https://chart.googleapis.com/chart?chs=400x400&cht=qr&chl=https%3A%2F%2Fapps.apple.com%2Fbr%2Fapp%2Fpixelmator-photo%2Fid1444636541&chld=L|0');return false;">C&oacute;digo QR</a></span></div>
                </div>
]]>
</content:encoded>
<wfw:commentRss>https://macmagazine.com.br/post/2021/12/16/pixelmator-photo-chega-ao-iphone/feed/</wfw:commentRss>
<slash:comments>0</slash:comments>
<post-id xmlns="com-wordpress:feed-additions:1">841702</post-id>
<media:content xmlns:media="http://search.yahoo.com/mrss/" medium="image" type="image/jpeg" url="https://macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-Icon.png" width="1024" height="1024" />
</item>
<item>
    <title>M1 Max exporta vídeos ProRes 3x mais rápido do que o Mac Pro</title>
    <link>https://macmagazine.com.br/post/2021/12/16/m1-max-exporta-videos-prores-3x-mais-rapido-do-que-o-mac-pro/</link>
    <comments>https://macmagazine.com.br/post/2021/12/16/m1-max-exporta-videos-prores-3x-mais-rapido-do-que-o-mac-pro/#respond</comments>
    <dc:creator>
        <![CDATA[Luiz Gustavo Ribeiro]]>
    </dc:creator>
    <pubDate>Thu, 16 Dec 2021 14:53:32 +0000</pubDate>
    <category>
        <![CDATA[Apple]]>
    </category>
    <category>
        <![CDATA[Hardware]]>
    </category>
    <category>
        <![CDATA[Mac]]>
    </category>
    <category>
        <![CDATA[Software]]>
    </category>
    <category>
        <![CDATA[Afterburner]]>
    </category>
    <category>
        <![CDATA[armazenamento]]>
    </category>
    <category>
        <![CDATA[benchmarks]]>
    </category>
    <category>
        <![CDATA[chip M1 Max]]>
    </category>
    <category>
        <![CDATA[Desempenho]]>
    </category>
    <category>
        <![CDATA[exportação]]>
    </category>
    <category>
        <![CDATA[Mac Pro]]>
    </category>
    <category>
        <![CDATA[MacBook Pro]]>
    </category>
    <category>
        <![CDATA[ProRes]]>
    </category>
    <category>
        <![CDATA[testes]]>
    </category>
    <category>
        <![CDATA[Velocidade]]>
    </category>
    <guid isPermaLink="false">https://macmagazine.com.br/?p=841746</guid>
    <description>
        <![CDATA[Não é de hoje que a performance do todo poderoso Mac Pro, lançado em 2019, é comparada à&#8230;]]>
    </description>
    <content:encoded>
        <![CDATA[<img width="1200" height="675" src="https://macmagazine.com.br/wp-content/uploads/2021/12/16-MacBook-Pro-2021-1260x709.jpg" class="webfeedsFeaturedVisual wp-post-image" alt="MacBook Pro" style="display: block; margin: auto; margin-bottom: 5px;max-width: 100%;" link_thumbnail="" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/16-MacBook-Pro-2021-1260x709.jpg 1260w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-MacBook-Pro-2021-600x337.jpg 600w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-MacBook-Pro-2021-300x169.jpg 300w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-MacBook-Pro-2021-1536x864.jpg 1536w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-MacBook-Pro-2021-2048x1152.jpg 2048w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-MacBook-Pro-2021-380x214.jpg 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-MacBook-Pro-2021-800x450.jpg 800w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-MacBook-Pro-2021-1160x652.jpg 1160w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-MacBook-Pro-2021.jpg 2500w" sizes="(max-width: 1200px) 100vw, 1200px" /><p>Não é de hoje que a performance do todo poderoso <strong>Mac Pro</strong>, lançado em 2019, é comparada à de outros Macs. Com o passar do tempo, porém, é no mínimo natural que a<em>workstation</em> seja superada por outras máquinas mais recentes — como o novo<strong>MacBook Pro com chip M1 Max</strong> — em algumas situações.</p><p>Mais precisamente, novos testes de exportações de vídeo <strong>ProRes</strong><a href="https://www.macworld.com/article/559816/prores-codecs-apple-silicon-mac-performance.html">realizados pela <em>Macworld</em></a> mostram que o novo MacBook Pro topo-de-linha é <strong>3x mais rápido</strong> do que o Mac Pro — mesmo se você adicionar a<a href="https://www.apple.com/br/shop/product/MW682AM/A/placa-afterburner-da-apple">placa Afterburner</a> (de R$25 mil) na<em>workstation</em>, o chip M1 Max ainda é 2x mais rápido!</p><div class="wp-block-image"><figure class="aligncenter size-full is-resized"><a href="https://macmagazine.com.br/wp-content/uploads/2021/12/16-ProRes-benchmark.png"><img src="https://macmagazine.com.br/wp-content/uploads/2021/12/16-ProRes-benchmark.png" alt="Benchmark: exportação ProRes no Mac Pro e no MBP com M1 Max" class="wp-image-841771" width="612" height="635" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/16-ProRes-benchmark.png 1224w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-ProRes-benchmark-578x600.png 578w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-ProRes-benchmark-1214x1260.png 1214w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-ProRes-benchmark-289x300.png 289w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-ProRes-benchmark-380x394.png 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-ProRes-benchmark-800x830.png 800w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-ProRes-benchmark-1160x1204.png 1160w" sizes="(max-width: 612px) 100vw, 612px" /></a></figure></div><p>Apesar de surpreendentes, os resultados não são tão inesperados assim: o M1 Max inclui dois codificadores e decodificadores ProRes, superando de longe o único decodificador encontrado na placa Afterburner do Mac Pro.</p><p>Vale notar que esse é apenas um aspecto do comparativo entre o Mac Pro e o MacBook Pro com chip M1 Max; segundo a <em>Macworld</em>, o desempenho do novo MBP ainda não está no mesmo nível de um Mac Pro — o que inclui outros fluxos de trabalho, como R3D Raw e aplicativos 3D, como Octane X.</p><p>De volta ao ProRes, a <em>Macworld</em> argumenta que a capacidade dos iPhones 13 Pro [Max] de gravar nesse formato é atualmente um &#8220;truque&#8221;, já que os dispositivos possuem uma capacidade de armazenamento limitada (mesmo com até 1TB), mas que isso certamente melhorará com o tempo.</p><hr><div class="appbox"><div class="appbox-icon"><a href="https://apple.sjv.io/gVxDO"><img width="600" height="578" src="https://macmagazine.com.br/wp-content/uploads/2021/10/18-mbp-14-miniatura-600x578.jpeg" alt="MacBook Pro de 14 polegadas (miniatura)" class="wp-image-826836" srcset="https://macmagazine.com.br/wp-content/uploads/2021/10/18-mbp-14-miniatura-600x578.jpeg 600w, https://macmagazine.com.br/wp-content/uploads/2021/10/18-mbp-14-miniatura-300x289.jpeg 300w, https://macmagazine.com.br/wp-content/uploads/2021/10/18-mbp-14-miniatura-380x366.jpeg 380w, https://macmagazine.com.br/wp-content/uploads/2021/10/18-mbp-14-miniatura.jpeg 800w" sizes="(max-width: 600px) 100vw, 600px" /></a></div><div class="appbox-details"><span class="appbox-name"><a href="https://apple.sjv.io/gVxDO">MacBooks Pro de 14&#8243; e 16&#8243;</a></span><span class="appbox-de">de <strong>Apple</strong></span><span><small><strong>Preço à vista:</strong> a partir de R$24.299,10<br><strong>Preço parcelado:</strong> em até 12x de R$2.249,92<br><strong>Características:</strong> M1 Pro ou M1 Max<br><strong>Cores:</strong> cinza espacial ou prateado<br><strong>Lançamento:</strong> 2021</small></span></div><div class="appbox-badge"><span style="float: right;"><a href="https://apple.sjv.io/gVxDO" class="botaoComprar">Comprar</a></span></div></div><p class="notaTransparencia">NOTA DE TRANSPARÊNCIA: O <strong><em>MacMagazine</em></strong> recebe uma pequena comissão de vendas concluídas por meio de links deste post, mas você, como consumidor, não paga nada mais pelos produtos comprando pelos nossos links de afiliado.</p><p><span class="credito">via <a href="https://9to5mac.com/2021/12/16/m1-max-prores-benchmark/">9to5Mac</a></span></p>
]]>
</content:encoded>
<wfw:commentRss>https://macmagazine.com.br/post/2021/12/16/m1-max-exporta-videos-prores-3x-mais-rapido-do-que-o-mac-pro/feed/</wfw:commentRss>
<slash:comments>0</slash:comments>
<post-id xmlns="com-wordpress:feed-additions:1">841746</post-id>
<media:content xmlns:media="http://search.yahoo.com/mrss/" medium="image" type="image/jpeg" url="https://macmagazine.com.br/wp-content/uploads/2021/12/16-MacBook-Pro-2021-1260x709.jpg" width="1200" height="675" />
</item>
<item>
    <title>Vídeo: caixa de HomePod é, na verdade, uma… bomba de glitter!</title>
    <link>https://macmagazine.com.br/post/2021/12/16/video-caixa-de-homepod-e-na-verdade-uma-bomba-de-glitter/</link>
    <comments>https://macmagazine.com.br/post/2021/12/16/video-caixa-de-homepod-e-na-verdade-uma-bomba-de-glitter/#respond</comments>
    <dc:creator>
        <![CDATA[Bruno Santana]]>
    </dc:creator>
    <pubDate>Thu, 16 Dec 2021 13:30:00 +0000</pubDate>
    <category>
        <![CDATA[Humor]]>
    </category>
    <category>
        <![CDATA[Off-Topic]]>
    </category>
    <category>
        <![CDATA[Vídeos]]>
    </category>
    <category>
        <![CDATA[bomba]]>
    </category>
    <category>
        <![CDATA[Caixa]]>
    </category>
    <category>
        <![CDATA[engenharia]]>
    </category>
    <category>
        <![CDATA[glitter]]>
    </category>
    <category>
        <![CDATA[HomePod]]>
    </category>
    <category>
        <![CDATA[Jony Ive]]>
    </category>
    <category>
        <![CDATA[ladrão]]>
    </category>
    <category>
        <![CDATA[ladrões]]>
    </category>
    <category>
        <![CDATA[Mark Rober]]>
    </category>
    <category>
        <![CDATA[peça]]>
    </category>
    <category>
        <![CDATA[vídeo]]>
    </category>
    <guid isPermaLink="false">https://macmagazine.com.br/?p=841720</guid>
    <description>
        <![CDATA[Talvez o nome Mark Rober não desperte nenhuma lembrança na sua cabeça, mas você possivelmente já ouviu falar&#8230;]]>
    </description>
    <content:encoded>
        <![CDATA[<img width="1200" height="675" src="https://macmagazine.com.br/wp-content/uploads/2021/12/16-glitter-homepod-1260x709.jpg" class="webfeedsFeaturedVisual wp-post-image" alt="Bomba de glitter em caixa de HomePod, por Mark Rober" style="display: block; margin: auto; margin-bottom: 5px;max-width: 100%;" link_thumbnail="" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/16-glitter-homepod-1260x709.jpg 1260w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-glitter-homepod-600x338.jpg 600w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-glitter-homepod-300x169.jpg 300w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-glitter-homepod-380x214.jpg 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-glitter-homepod-800x450.jpg 800w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-glitter-homepod-1160x653.jpg 1160w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-glitter-homepod.jpg 1280w" sizes="(max-width: 1200px) 100vw, 1200px" /><p>Talvez o nome <strong>Mark Rober</strong> não desperte nenhuma lembrança na sua cabeça, mas você possivelmente já ouviu falar dos seus &#8220;feitos&#8221; natalinos: pelos últimos quatro anos, o<em>YouTuber</em> — e ex-engenheiro da NASA, que<a href="https://macmagazine.com.br/post/2018/06/27/youtuber-esta-trabalhando-em-projeto-de-vr-para-o-sistema-de-carros-autonomos-da-apple/">já trabalhou inclusive com a Apple </a>— empreendeu esforços cada vez maiores para construir<strong>&#8220;bombas de glitter&#8221;</strong> dentro de caixas — tudo para pregar uma bela duma peça em ladrões que roubam pacotes deixados nas portas das casas dos seus donos.</p><p>Pois em 2021, Rober superou todas as tentativas anteriores: a &#8220;Bomba de Glitter 4.0&#8221; tem quatro smartphones para filmar a reação dos bandidos de qualquer ângulo, um sistema pneumático que faz a tampa da caixa saltar para fora no momento do clímax, uma buzina embutida para assustar ainda mais a pessoa, um microfone para gravar todos os acontecimentos e muito mais.</p><p>O melhor: todo esse pacote foi colocado dentro de uma caixa (falsa) de <strong>HomePod</strong> — com direito a um clipe introdutório no maior estilo Apple/Jony Ive, como vocês podem ver a partir dos 4:40 no vídeo abaixo.</p><figure class="wp-block-embed aligncenter is-type-video is-provider-youtube wp-block-embed-youtube wp-embed-aspect-16-9 wp-has-aspect-ratio"><div class="wp-block-embed__wrapper"><iframe loading="lazy" title="EXPLODING Glitter Bomb 4.0 vs. Package Thieves" width="1200" height="675" src="https://www.youtube.com/embed/3c584TGG7jQ?feature=oembed" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div></figure><p>Quem lê o <strong><em>MacMagazine</em></strong> há algum tempo possivelmente se lembrará que esta não é a primeira vez do HomePod nas pegadinhas de Rober: ele já fez uma das suas bombas de glitter disfarçadas dentro de uma caixa do finado alto-falante, <a href="https://macmagazine.com.br/post/2018/12/18/youtuber-usa-homepod-como-isca-para-aplicar-pegadinha-em-ladroes/">como comentamos por aqui em 2018</a>. A versão de 2021, entretanto, é<em>muito</em> mais avançada.</p><p>Vale conferir também um vídeo de <em>making of </em>publicado no canal do estúdio Bubba&#8217;s LA, que mostra como foram realizados os efeitos do vídeo principal — efeitos práticos, vale notar, com intervenção mínima do computador.</p><figure class="wp-block-embed aligncenter is-type-video is-provider-youtube wp-block-embed-youtube wp-embed-aspect-16-9 wp-has-aspect-ratio"><div class="wp-block-embed__wrapper"><iframe loading="lazy" title="Mark Rober Glitterbomb 4.0 vs. Porch Pirates BTS" width="1200" height="675" src="https://www.youtube.com/embed/ZIdh7hxz1G8?feature=oembed" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div></figure><p>Muito divertido — exceto, claro, para os espertinhos que ficarão com glitter em todos os centímetros quadrados dos seus corpos até o Natal que vem… <img src="https://s.w.org/images/core/emoji/13.1.0/72x72/1f61c.png" alt="😜" class="wp-smiley" style="height: 1em; max-height: 1em;" /></p><p><span class="credito">via <a href="https://www.techspot.com/news/92634-glitter-bomb-40-makes-porch-pirates-pay.html">TechSpot</a></span></p>
]]>
</content:encoded>
<wfw:commentRss>https://macmagazine.com.br/post/2021/12/16/video-caixa-de-homepod-e-na-verdade-uma-bomba-de-glitter/feed/</wfw:commentRss>
<slash:comments>0</slash:comments>
<post-id xmlns="com-wordpress:feed-additions:1">841720</post-id>
<media:content xmlns:media="http://search.yahoo.com/mrss/" medium="image" type="image/jpeg" url="https://macmagazine.com.br/wp-content/uploads/2021/12/16-glitter-homepod-1260x709.jpg" width="1200" height="675" />
</item>
<item>
    <title>Logitech lança no Brasil linha POP com periféricos e acessórios</title>
    <link>https://macmagazine.com.br/post/2021/12/16/logitech-lanca-no-brasil-linha-pop-com-perifericos-e-acessorios/</link>
    <comments>https://macmagazine.com.br/post/2021/12/16/logitech-lanca-no-brasil-linha-pop-com-perifericos-e-acessorios/#respond</comments>
    <dc:creator>
        <![CDATA[Luiz Gustavo Ribeiro]]>
    </dc:creator>
    <pubDate>Thu, 16 Dec 2021 13:10:00 +0000</pubDate>
    <category>
        <![CDATA[Acessórios]]>
    </category>
    <category>
        <![CDATA[Design]]>
    </category>
    <category>
        <![CDATA[Bluetooth]]>
    </category>
    <category>
        <![CDATA[Brasil]]>
    </category>
    <category>
        <![CDATA[cores]]>
    </category>
    <category>
        <![CDATA[Desk Mat]]>
    </category>
    <category>
        <![CDATA[emoji]]>
    </category>
    <category>
        <![CDATA[lançamento]]>
    </category>
    <category>
        <![CDATA[linha POP]]>
    </category>
    <category>
        <![CDATA[Logitech]]>
    </category>
    <category>
        <![CDATA[Mouse]]>
    </category>
    <category>
        <![CDATA[Mouse Pad]]>
    </category>
    <category>
        <![CDATA[periféricos]]>
    </category>
    <category>
        <![CDATA[Pop Keys]]>
    </category>
    <category>
        <![CDATA[POP Mouse]]>
    </category>
    <category>
        <![CDATA[preço]]>
    </category>
    <category>
        <![CDATA[sem fio]]>
    </category>
    <category>
        <![CDATA[teclado mecânico]]>
    </category>
    <guid isPermaLink="false">https://macmagazine.com.br/?p=841717</guid>
    <description>
        <![CDATA[No mês passado, a Logitech anunciou uma nova linha de periféricos que foge um pouco dos tons sóbrios&#8230;]]>
    </description>
    <content:encoded>
        <![CDATA[<img width="1200" height="675" src="https://macmagazine.com.br/wp-content/uploads/2021/12/16-Logitech-POP-1260x709.jpg" class="webfeedsFeaturedVisual wp-post-image" alt="Logitech POP" style="display: block; margin: auto; margin-bottom: 5px;max-width: 100%;" link_thumbnail="" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/16-Logitech-POP-1260x709.jpg 1260w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-Logitech-POP-600x338.jpg 600w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-Logitech-POP-300x169.jpg 300w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-Logitech-POP-380x214.jpg 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-Logitech-POP-800x450.jpg 800w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-Logitech-POP-1160x653.jpg 1160w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-Logitech-POP.jpg 1280w" sizes="(max-width: 1200px) 100vw, 1200px" /><p>No mês passado, a <strong>Logitech</strong><a href="https://macmagazine.com.br/post/2021/11/10/logitech-lanca-mouse-teclado-coloridos-com-foco-em-emojis/">anunciou uma nova linha de periféricos</a> que foge um pouco dos tons sóbrios e monocromáticos. Falo da<strong>linha POP</strong>, que estreou com teclados e mouse coloridíssimos da nova série<em>Vibrant Studio</em> — a qual está agora disponível no<strong>Brasil</strong>.</p><p>Como havíamos informado, a linha é composta pelo <strong><a href="https://www.logitech.com/pt-br/products/mice/pop-wireless-mouse.910-006550.html">POP Mouse</a></strong> e pelo <strong><a href="https://www.logitech.com/pt-br/products/keyboards/pop-keys-wireless-mechanical.920-010711.html">POP Keys</a></strong>, os quais são sem fio e apresentam a <strong>função emoji</strong> — a qual permite acessar facilmente o painel de emojis, definir uma opção padrão e personalizar teclas/ações.</p><figure class="wp-block-gallery aligncenter columns-3 is-cropped"><ul class="blocks-gallery-grid"><li class="blocks-gallery-item"><figure><a href="https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-3.jpg"><img width="1260" height="708" src="https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-3-1260x708.jpg" alt="Acessórios POP (mouse e teclado) da Logitech" data-id="832897" data-full-url="https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-3.jpg" data-link="https://macmagazine.com.br/post/2021/11/10/logitech-lanca-mouse-teclado-coloridos-com-foco-em-emojis/09-logitech-pop-mouse-teclado-3/" class="wp-image-832897" srcset="https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-3-1260x708.jpg 1260w, https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-3-600x337.jpg 600w, https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-3-300x169.jpg 300w, https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-3-1536x863.jpg 1536w, https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-3-380x214.jpg 380w, https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-3-800x450.jpg 800w, https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-3-1160x652.jpg 1160w, https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-3.jpg 1594w" sizes="(max-width: 1260px) 100vw, 1260px" /></a></figure></li><li class="blocks-gallery-item"><figure><a href="https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-2.jpg"><img width="1260" height="708" src="https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-2-1260x708.jpg" alt="Acessórios POP (mouse e teclado) da Logitech" data-id="832896" data-full-url="https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-2.jpg" data-link="https://macmagazine.com.br/post/2021/11/10/logitech-lanca-mouse-teclado-coloridos-com-foco-em-emojis/09-logitech-pop-mouse-teclado-2/" class="wp-image-832896" srcset="https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-2-1260x708.jpg 1260w, https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-2-600x337.jpg 600w, https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-2-300x169.jpg 300w, https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-2-1536x863.jpg 1536w, https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-2-380x214.jpg 380w, https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-2-800x450.jpg 800w, https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-2-1160x652.jpg 1160w, https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-2.jpg 1594w" sizes="(max-width: 1260px) 100vw, 1260px" /></a></figure></li><li class="blocks-gallery-item"><figure><a href="https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado.jpg"><img width="1260" height="708" src="https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-1260x708.jpg" alt="Acessórios POP (mouse e teclado) da Logitech" data-id="832895" data-full-url="https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado.jpg" data-link="https://macmagazine.com.br/post/2021/11/10/logitech-lanca-mouse-teclado-coloridos-com-foco-em-emojis/09-logitech-pop-mouse-teclado/" class="wp-image-832895" srcset="https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-1260x708.jpg 1260w, https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-600x337.jpg 600w, https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-300x169.jpg 300w, https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-1536x863.jpg 1536w, https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-380x214.jpg 380w, https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-800x450.jpg 800w, https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-1160x652.jpg 1160w, https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado.jpg 1594w" sizes="(max-width: 1260px) 100vw, 1260px" /></a></figure></li></ul></figure><p>Tanto o teclado quanto o mouse POP podem se conectar a até três dispositivos ao mesmo tempo por meio de Bluetooth ou do receptor sem fio Logi Bolt. Cada um também vem com a garantia de durabilidade e bateria de longa duração.</p><p>O teclado mecânico <a href="https://www.logitech.com/pt-br/products/keyboards/pop-keys-wireless-mechanical.920-010713.html">POP Keys</a> e o<a href="https://www.logitech.com/pt-br/products/mice/pop-wireless-mouse.910-006550.html">POP Mouse</a> já estão disponíveis pelos preços sugeridos de<strong>R$800</strong> e<strong>R$180</strong>, respectivamente.</p><h2>Acessórios</h2><p>A Logitech também também lançou seus novos <a href="https://www.logitech.com/pt-br/products/mice/mouse-pad-studio-series.956-000035.html"><strong>Mouse Pad</strong></a> e <a href="https://www.logitech.com/pt-br/products/mice/desk-mat-studio-series.956-000048.html"><strong>Desk Mat</strong></a> para compor os periféricos da linha POP. Além de coloridos, eles são macios, suaves e antiderrapantes. Segundo a fabricante, a superfície lisa, confortável e de trama fina proporciona um deslizamento silencioso e sem esforço para o mouse.&nbsp;</p><figure class="wp-block-gallery aligncenter columns-2 is-cropped"><ul class="blocks-gallery-grid"><li class="blocks-gallery-item"><figure><a href="https://macmagazine.com.br/wp-content/uploads/2021/12/16-logi-mouse-pad.png"><img width="1260" height="709" src="https://macmagazine.com.br/wp-content/uploads/2021/12/16-logi-mouse-pad-1260x709.png" alt="Mouse Pad da Logitech" data-id="841723" data-full-url="https://macmagazine.com.br/wp-content/uploads/2021/12/16-logi-mouse-pad.png" data-link="https://macmagazine.com.br/?attachment_id=841723" class="wp-image-841723" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/16-logi-mouse-pad-1260x709.png 1260w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-logi-mouse-pad-600x337.png 600w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-logi-mouse-pad-300x169.png 300w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-logi-mouse-pad-1536x864.png 1536w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-logi-mouse-pad-380x214.png 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-logi-mouse-pad-800x450.png 800w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-logi-mouse-pad-1160x652.png 1160w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-logi-mouse-pad.png 1860w" sizes="(max-width: 1260px) 100vw, 1260px" /></a></figure></li><li class="blocks-gallery-item"><figure><a href="https://macmagazine.com.br/wp-content/uploads/2021/12/16-logi-desk-mat.png"><img width="1260" height="709" src="https://macmagazine.com.br/wp-content/uploads/2021/12/16-logi-desk-mat-1260x709.png" alt="Desk Mat da Logitech" data-id="841722" data-full-url="https://macmagazine.com.br/wp-content/uploads/2021/12/16-logi-desk-mat.png" data-link="https://macmagazine.com.br/?attachment_id=841722" class="wp-image-841722" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/16-logi-desk-mat-1260x709.png 1260w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-logi-desk-mat-600x337.png 600w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-logi-desk-mat-300x169.png 300w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-logi-desk-mat-1536x864.png 1536w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-logi-desk-mat-380x214.png 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-logi-desk-mat-800x450.png 800w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-logi-desk-mat-1160x652.png 1160w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-logi-desk-mat.png 1860w" sizes="(max-width: 1260px) 100vw, 1260px" /></a></figure></li></ul></figure><p>Ambos os acessórios estão disponíveis no Brasil pelos preços sugeridos de<strong> R$60</strong> (Mouse Pad) e<strong>R$140</strong> (Desk Mat).</p>
]]>
</content:encoded>
<wfw:commentRss>https://macmagazine.com.br/post/2021/12/16/logitech-lanca-no-brasil-linha-pop-com-perifericos-e-acessorios/feed/</wfw:commentRss>
<slash:comments>0</slash:comments>
<post-id xmlns="com-wordpress:feed-additions:1">841717</post-id>
<media:content xmlns:media="http://search.yahoo.com/mrss/" medium="image" type="image/jpeg" url="https://macmagazine.com.br/wp-content/uploads/2021/12/16-Logitech-POP-1260x709.jpg" width="1200" height="675" />
</item>
<item>
    <title>★ Um iPhone seminovo pode ser aquele superpresente!</title>
    <link>https://macmagazine.com.br/post/2021/12/16/um-iphone-seminovo-pode-ser-aquele-superpresente/</link>
    <comments>https://macmagazine.com.br/post/2021/12/16/um-iphone-seminovo-pode-ser-aquele-superpresente/#respond</comments>
    <dc:creator>
        <![CDATA[Informe Publicitário]]>
    </dc:creator>
    <pubDate>Thu, 16 Dec 2021 13:00:00 +0000</pubDate>
    <category>
        <![CDATA[Apple]]>
    </category>
    <category>
        <![CDATA[Destaques]]>
    </category>
    <category>
        <![CDATA[Dicas]]>
    </category>
    <category>
        <![CDATA[Dinheiro]]>
    </category>
    <category>
        <![CDATA[Publieditorial]]>
    </category>
    <category>
        <![CDATA[Telefonia]]>
    </category>
    <category>
        <![CDATA[aparelho]]>
    </category>
    <category>
        <![CDATA[assistência]]>
    </category>
    <category>
        <![CDATA[assistência técnica]]>
    </category>
    <category>
        <![CDATA[assistência técnica especializada]]>
    </category>
    <category>
        <![CDATA[Brasília]]>
    </category>
    <category>
        <![CDATA[campinas]]>
    </category>
    <category>
        <![CDATA[compra]]>
    </category>
    <category>
        <![CDATA[compras]]>
    </category>
    <category>
        <![CDATA[cupom]]>
    </category>
    <category>
        <![CDATA[desconto]]>
    </category>
    <category>
        <![CDATA[device]]>
    </category>
    <category>
        <![CDATA[dispositivo]]>
    </category>
    <category>
        <![CDATA[garantia]]>
    </category>
    <category>
        <![CDATA[iCaiu]]>
    </category>
    <category>
        <![CDATA[iCaiu Store]]>
    </category>
    <category>
        <![CDATA[iPhone]]>
    </category>
    <category>
        <![CDATA[iPhone 11]]>
    </category>
    <category>
        <![CDATA[iPhone 12 Pro Max]]>
    </category>
    <category>
        <![CDATA[iPhone 7]]>
    </category>
    <category>
        <![CDATA[iPhone XR]]>
    </category>
    <category>
        <![CDATA[loja]]>
    </category>
    <category>
        <![CDATA[oferta]]>
    </category>
    <category>
        <![CDATA[Prêmio Reclame Aqui]]>
    </category>
    <category>
        <![CDATA[reparo]]>
    </category>
    <category>
        <![CDATA[Rio de Janeiro]]>
    </category>
    <category>
        <![CDATA[São Paulo]]>
    </category>
    <category>
        <![CDATA[seminovo]]>
    </category>
    <category>
        <![CDATA[seminovos]]>
    </category>
    <category>
        <![CDATA[tela]]>
    </category>
    <category>
        <![CDATA[usado]]>
    </category>
    <category>
        <![CDATA[usados]]>
    </category>
    <category>
        <![CDATA[venda]]>
    </category>
    <category>
        <![CDATA[vendas]]>
    </category>
    <guid isPermaLink="false">https://macmagazine.com.br/?p=841639</guid>
    <description>
        <![CDATA[Com a alta do dólar e a inflação acima de dois dígitos, comprar um iPhone novo se tornou&#8230;]]>
    </description>
    <content:encoded>
        <![CDATA[<img width="1200" height="800" src="https://macmagazine.com.br/wp-content/uploads/2021/12/sabri-tuzcu-rYnQwRsNpE0-unsplash-1260x840.jpg" class="webfeedsFeaturedVisual wp-post-image" alt="" style="display: block; margin: auto; margin-bottom: 5px;max-width: 100%;" link_thumbnail="" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/sabri-tuzcu-rYnQwRsNpE0-unsplash-1260x840.jpg 1260w, https://macmagazine.com.br/wp-content/uploads/2021/12/sabri-tuzcu-rYnQwRsNpE0-unsplash-600x400.jpg 600w, https://macmagazine.com.br/wp-content/uploads/2021/12/sabri-tuzcu-rYnQwRsNpE0-unsplash-300x200.jpg 300w, https://macmagazine.com.br/wp-content/uploads/2021/12/sabri-tuzcu-rYnQwRsNpE0-unsplash-1536x1024.jpg 1536w, https://macmagazine.com.br/wp-content/uploads/2021/12/sabri-tuzcu-rYnQwRsNpE0-unsplash-2048x1365.jpg 2048w, https://macmagazine.com.br/wp-content/uploads/2021/12/sabri-tuzcu-rYnQwRsNpE0-unsplash-380x253.jpg 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/sabri-tuzcu-rYnQwRsNpE0-unsplash-800x533.jpg 800w, https://macmagazine.com.br/wp-content/uploads/2021/12/sabri-tuzcu-rYnQwRsNpE0-unsplash-1160x773.jpg 1160w" sizes="(max-width: 1200px) 100vw, 1200px" /><p>Com a alta do dólar e a inflação acima de dois dígitos, comprar um iPhone novo se tornou algo difícil de ser alcançado por nós, meros mortais. Tendo <a href="https://macmagazine.com.br/post/2021/09/15/quantos-dias-preciso-trabalhar-para-comprar-um-iphone-13-pro/">os iPhones mais caros do mundo</a>, para nós,<em>Applemaníacos</em>, estar sempre com as mais recentes novidades da empresa não é tarefa fácil.</p><p>Mas não perca as suas esperanças, ainda, pois a dica que damos a você é a de investir nos aparelhos seminovos, os queridinhos dos brasileiros nesses anos de vacas magras. E para quem está vendo este artigo antes do dia 22 de dezembro, saiba que você poderá aproveitar <strong>um desconto especial na iCaiu Store</strong> para os leitores do<em><strong>MacMagazine</strong></em>, no fim deste post! <img src="https://s.w.org/images/core/emoji/13.1.0/72x72/1f603.png" alt="😃" class="wp-smiley" style="height: 1em; max-height: 1em;" /></p><p>No Brasil, entre os dez aparelhos seminovos mais comprados, seis deles são iPhones — com o já &#8220;velhinho&#8221; (porém poderoso) iPhone 7 liderando as vendas nacionais. Mas comprar um iPhone seminovo não é algo que se deva fazer sem tomar alguns cuidados, pois sabemos de várias histórias de pessoas que compraram um aparelho em alguns classificados online com preço muito atrativo para acabar recebendo um tijolo pelos Correios.</p><p>Não podemos esquecer, também, dos riscos de comprar um aparelho com defeito, bloqueado ou até mesmo roubado. Por isso, tome muito cuidado com iPhones muito baratos — ainda que pareça uma boa compra, pode se tornar uma tremenda dor de cabeça.</p><p>Então o que você deve fazer para conseguir comprar um iPhone seminovo sem correr riscos?</p><h2>iPhone com procedência</h2><p>A primeira coisa que você deve investigar é a procedência desse aparelho e a reputação do vendedor. Quando queremos pagar mais barato, os classificados tendem a ser nossa melhor opção, mas os riscos são muito grandes. Quem se sente seguro encontrando um desconhecido levando mais de R$1.000 em dinheiro para comprar um <em>device</em>? Não sei você, mas eu prefiro não arriscar.</p><p>Para eliminar os riscos, só nos resta ir atrás de lojas confiáveis que vendam esses aparelhos usados, mas aí os preços acabam sendo mais salgados — e, muitas vezes, o seu tão sonhado iPhone 11 acaba se tornando um iPhone XR para caber no bolso.</p><h2>Compare, sempre!</h2><p>A solução para conseguir comprar o iPhone dos sonhos é pesquisar por aí e comparar os preços, que podem variar em até 15-20%, a depender do modelo, nas lojas que vendem seminovos.</p><p>Um iPhone XS Max de 256GB cinza espacial na líder de vendas de smartphones usados não sai por menos de R$4.259, por exemplo. Já o mesmo <a href="https://store.icaiu.com.br/?utm_source=macmagazine&amp;utm_medium=publipos&amp;utm_campaign=natalstore2021&amp;utm_id=publimacmagazine">iPhone na iCaiu Store</a>,<a href="https://store.icaiu.com.br/buy/product/iphone-xs-max-256GB-cinzaespacial-5564437?utm_source=macmagazine&amp;utm_medium=publipos&amp;utm_campaign=natalstore2021&amp;utm_id=publimacmagazine">sai por apenas R$3.970</a>, quase R$300 mais barato. Com essa diferença, você poderia comprar todos os acessórios necessários para deixar seu aparelho &#8220;pronto para a guerra&#8221;.</p><h2>Onde comprar um iPhone barato com garantia?</h2><p>Nenhuma loja de smartphones usados oferece uma garantia tão longa quanto a iCaiu. A rede especializada em <em>devices</em> Apple com mais de 20 lojas em<a href="https://www.icaiu.com.br/local/sao-paulo/?utm_source=macmagazine&amp;utm_medium=publipos&amp;utm_campaign=natalstore2021&amp;utm_id=publimacmagazine">São Paulo</a>,<a href="https://www.icaiu.com.br/local/rio-de-janeiro/?utm_source=macmagazine&amp;utm_medium=publipos&amp;utm_campaign=natalstore2021&amp;utm_id=publimacmagazine">Rio de Janeiro</a>,<a href="https://www.icaiu.com.br/local/sao-paulo/campinas/?utm_source=macmagazine&amp;utm_medium=publipos&amp;utm_campaign=natalstore2021&amp;utm_id=publimacmagazine">Campinas</a> e<a href="https://www.icaiu.com.br/local/distrito-federal/?utm_source=macmagazine&amp;utm_medium=publipos&amp;utm_campaign=natalstore2021&amp;utm_id=publimacmagazine">Distrito Federal</a> é a única onde todos os aparelhos possuem<strong>seis meses de garantia</strong>.</p><div class="wp-block-image"><figure class="aligncenter size-large"><img width="1260" height="840" src="https://macmagazine.com.br/wp-content/uploads/2021/12/sara-kurfess-KegwEO8r29E-unsplash-1260x840.jpg" alt="" class="wp-image-841728" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/sara-kurfess-KegwEO8r29E-unsplash-1260x840.jpg 1260w, https://macmagazine.com.br/wp-content/uploads/2021/12/sara-kurfess-KegwEO8r29E-unsplash-600x400.jpg 600w, https://macmagazine.com.br/wp-content/uploads/2021/12/sara-kurfess-KegwEO8r29E-unsplash-300x200.jpg 300w, https://macmagazine.com.br/wp-content/uploads/2021/12/sara-kurfess-KegwEO8r29E-unsplash-1536x1024.jpg 1536w, https://macmagazine.com.br/wp-content/uploads/2021/12/sara-kurfess-KegwEO8r29E-unsplash-2048x1365.jpg 2048w, https://macmagazine.com.br/wp-content/uploads/2021/12/sara-kurfess-KegwEO8r29E-unsplash-380x253.jpg 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/sara-kurfess-KegwEO8r29E-unsplash-800x533.jpg 800w, https://macmagazine.com.br/wp-content/uploads/2021/12/sara-kurfess-KegwEO8r29E-unsplash-1160x773.jpg 1160w" sizes="(max-width: 1260px) 100vw, 1260px" /></figure></div><p>Isso só é possível porque a iCaiu possui uma grande estrutura voltada a reparos de todos os tipos de aparelhos da Apple, com técnicos especializados. Isso permite com que a inovadora empresa, que oferece uma gama de serviços para nós, <em>Applemaníacos</em>, consiga garantir a procedência e a qualidade de todos os dispositivos comercializados pela iCaiu Store, o melhor<em>marketplace</em> entre donos de aparelhos da marca que nós tanto amamos.</p><p>Tendo cerca de 70 mil clientes satisfeitos e com um <em>marketplace</em> inovador, só a iCaiu consegue oferecer iPhones com preços próximos aos encontrados nos arriscados classificados, porém com a segurança de uma loja especializada. Além dos preços quase imbatíveis em todos os iPhones, a garantia de seis meses e o<strong>parcelamento em 10x sem juros</strong>, você não precisa ficar esperando sua compra chegar em casa nem correr o risco de ter seu novo iPhone extraviado, pois você pode ir em qualquer uma de<a href="https://www.icaiu.com.br/lojas/?utm_source=macmagazine&amp;utm_medium=publipos&amp;utm_campaign=natalstore2021&amp;utm_id=publimacmagazine">nossas lojas</a> retirar pessoalmente o seu aparelho.</p><p>Mas não pense que as vantagens param por aí: segundo o Código de Defesa do Consumidor, todos os produtos que você compra pela internet têm sete dias para serem devolvidos — e você, o seu dinheiro de volta. Isso é uma garantia para caso você se arrependa da sua compra, uma vez que você adquiriu o produto sem poder vê-lo fisicamente.</p><p>Mas a iCaiu, tendo tanta certeza de que você sairá satisfeito, oferece incríveis 15 dias de prazo para devolução, mesmo a compra sendo entregue fisicamente e não pelos Correios. Somente quem tem certeza da qualidade dos iPhones vendidos pode fazer uma coisa dessas! Por essas e outras, a iCaiu foi indicada ao <strong>Prêmio Reclame Aqui</strong> como a<strong>melhor <a href="https://www.icaiu.com.br/?utm_source=macmagazine&amp;utm_medium=publipos&amp;utm_campaign=natalstore2021&amp;utm_id=publimacmagazine">Assistência Técnica Apple</a> do Brasil</strong>.</p><h2>E se eu quiser comprar um iPhone 13, o que eu posso fazer?</h2><figure class="wp-block-gallery aligncenter columns-2 is-cropped"><ul class="blocks-gallery-grid"><li class="blocks-gallery-item"><figure><img width="828" height="1424" src="https://macmagazine.com.br/wp-content/uploads/2021/12/IMG_5315.jpg" alt="" data-id="841730" data-full-url="https://macmagazine.com.br/wp-content/uploads/2021/12/IMG_5315.jpg" data-link="https://macmagazine.com.br/?attachment_id=841730" class="wp-image-841730" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/IMG_5315.jpg 828w, https://macmagazine.com.br/wp-content/uploads/2021/12/IMG_5315-349x600.jpg 349w, https://macmagazine.com.br/wp-content/uploads/2021/12/IMG_5315-733x1260.jpg 733w, https://macmagazine.com.br/wp-content/uploads/2021/12/IMG_5315-174x300.jpg 174w, https://macmagazine.com.br/wp-content/uploads/2021/12/IMG_5315-380x654.jpg 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/IMG_5315-800x1376.jpg 800w" sizes="(max-width: 828px) 100vw, 828px" /></figure></li><li class="blocks-gallery-item"><figure><img width="828" height="1428" src="https://macmagazine.com.br/wp-content/uploads/2021/12/IMG_5314.jpg" alt="" data-id="841729" data-full-url="https://macmagazine.com.br/wp-content/uploads/2021/12/IMG_5314.jpg" data-link="https://macmagazine.com.br/?attachment_id=841729" class="wp-image-841729" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/IMG_5314.jpg 828w, https://macmagazine.com.br/wp-content/uploads/2021/12/IMG_5314-348x600.jpg 348w, https://macmagazine.com.br/wp-content/uploads/2021/12/IMG_5314-731x1260.jpg 731w, https://macmagazine.com.br/wp-content/uploads/2021/12/IMG_5314-174x300.jpg 174w, https://macmagazine.com.br/wp-content/uploads/2021/12/IMG_5314-380x655.jpg 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/IMG_5314-800x1380.jpg 800w" sizes="(max-width: 828px) 100vw, 828px" /></figure></li></ul></figure><p>Então você é um <em>early-adopter</em> que está sempre na frente de todo mundo quando o assunto é tecnologia e, principalmente, produtos da Apple? Ficou com a mão coçando em setembro com o lançamento do novo iPhone, mas como os preços são muito salgados ainda não conseguiu adquirir o seu? A iCaiu também é para você!</p><p>Infelizmente nosso foco é em seminovos com garantia, então até este momento só temos aparelhos da linha do iPhone 12, como um <a href="https://store.icaiu.com.br/buy/product/iphone-12-pro?utm_source=macmagazine&amp;utm_medium=publipos&amp;utm_campaign=natalstore2021&amp;utm_id=publimacmagazine">iPhone 12 Pro Max de 256GB branco</a>, que sai por apenas 10x de R$720. Mas não vamos lhe deixar na mão!</p><p>Vendendo seu iPhone antigo na iCaiu Store, você recebe mais por ele do que na empresa líder de mercado, porém sem a dor de cabeça de vender por conta própria para outra pessoa.</p><p>“Ah, mas meu iPhone 11 está com a tela trincada. Ninguém vai querer comprá-lo.&#8221; Se o seu iPhone precisa de reparos, a iCaiu também quebra esse galho para você! Vendendo ele pela iCaiu Store, você ganha 30% de desconto para a realização do reparo e só paga quando o seu aparelho for vendido, ou seja, não é cobrado nada na hora do reparo. Os custos do conserto são descontados do valor que você receberá com a venda ou em alguns poucos dias, caso você queira receber o valor antecipadamente.</p><p>Mesmo que você não esteja planejando comprar o novo iPhone mas está apertado, precisando de uma grana boa, entre no site da iCaiu e <a href="https://store.icaiu.com.br/vender_iphone/usado?utm_source=macmagazine&amp;utm_medium=publipos&amp;utm_campaign=natalstore2021&amp;utm_id=publimacmagazine">faça uma avaliação do seu aparelho para ver quanto ele vale</a>. É garantia de que você encontrará o melhor preço oferecido pelo seu aparelho antigo.</p><h2>Desconto de Natal</h2><p>Agora que você já sabe das vantagens de <a href="https://store.icaiu.com.br/comprar">comprar um iPhone seminovo</a> e que pode descolar um bom dinheiro vendendo seu aparelho usado, que tal aproveitar o momento em que você está com um extra na carteira e dar aquele presente inesquecível para aquela pessoa especial que você ama tanto?</p><div class="wp-block-image"><figure class="aligncenter size-large"><img width="1008" height="1260" src="https://macmagazine.com.br/wp-content/uploads/2021/12/kevin-bhagat-Co-usQ-kpO0-unsplash-1008x1260.jpg" alt="" class="wp-image-841732" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/kevin-bhagat-Co-usQ-kpO0-unsplash-1008x1260.jpg 1008w, https://macmagazine.com.br/wp-content/uploads/2021/12/kevin-bhagat-Co-usQ-kpO0-unsplash-480x600.jpg 480w, https://macmagazine.com.br/wp-content/uploads/2021/12/kevin-bhagat-Co-usQ-kpO0-unsplash-240x300.jpg 240w, https://macmagazine.com.br/wp-content/uploads/2021/12/kevin-bhagat-Co-usQ-kpO0-unsplash-1229x1536.jpg 1229w, https://macmagazine.com.br/wp-content/uploads/2021/12/kevin-bhagat-Co-usQ-kpO0-unsplash-1638x2048.jpg 1638w, https://macmagazine.com.br/wp-content/uploads/2021/12/kevin-bhagat-Co-usQ-kpO0-unsplash-380x475.jpg 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/kevin-bhagat-Co-usQ-kpO0-unsplash-800x1000.jpg 800w, https://macmagazine.com.br/wp-content/uploads/2021/12/kevin-bhagat-Co-usQ-kpO0-unsplash-1160x1450.jpg 1160w, https://macmagazine.com.br/wp-content/uploads/2021/12/kevin-bhagat-Co-usQ-kpO0-unsplash-scaled.jpg 3277w" sizes="(max-width: 1008px) 100vw, 1008px" /></figure></div><p>Dia 25/12 está chegando, mas ainda dá tempo de comprar um excelente iPhone na iCaiu Store para dar de presente para alguém — ou, quem sabe, um mais do que merecido de você para você mesmo, pois nós sabemos que este ano não foi fácil e você lutou bravamente!</p><p>Nada mais justo do que realizar aquele seu sonho antigo de ter um iPhone <em>top</em> para começar 2022 com a corda toda.<img src="https://s.w.org/images/core/emoji/13.1.0/72x72/1f601.png" alt="😁" class="wp-smiley" style="height: 1em; max-height: 1em;" /><br><br>E, para facilitar ainda mais, a iCaiu está dando um desconto para os fãs do <em>MM</em>. Usando o cupom<code>MACMAGAZINE10</code>, você terá<strong>10% de desconto</strong> em qualquer aparelho no site da iCaiu Store se comprar no site até o dia 22/12. Então corra e garanta logo o seu porque temos<strong>estoque limitado</strong>!</p><ul><li><strong>Cupom</strong>:<code>MACMAGAZINE10</code></li><li><strong>Validade:</strong> 22 de dezembro de 2021</li><li><strong>Onde</strong>: no site<a href="http://store.icaiu.com.br">store.icaiu.com.br</a></li><li><strong>Retirada em lojas físicas</strong>: Rio de Janeiro, São Paulo, Brasília e Campinas</li></ul><p>Ah, os preços da iCaiu Store citados no texto acima estão *sem* o desconto extra de Natal para os leitores do <em><strong>MacMagazine</strong></em>, hein! <img src="https://s.w.org/images/core/emoji/13.1.0/72x72/1f609.png" alt="😉" class="wp-smiley" style="height: 1em; max-height: 1em;" />&nbsp;</p>
]]>
</content:encoded>
<wfw:commentRss>https://macmagazine.com.br/post/2021/12/16/um-iphone-seminovo-pode-ser-aquele-superpresente/feed/</wfw:commentRss>
<slash:comments>0</slash:comments>
<post-id xmlns="com-wordpress:feed-additions:1">841639</post-id>
<media:content xmlns:media="http://search.yahoo.com/mrss/" medium="image" type="image/jpeg" url="https://macmagazine.com.br/wp-content/uploads/2021/12/sabri-tuzcu-rYnQwRsNpE0-unsplash-1260x840.jpg" width="1200" height="800" />
</item>
<item>
    <title>iPhones 7, 8 e X são os mais vendidos na OLX</title>
    <link>https://macmagazine.com.br/post/2021/12/16/iphones-7-8-e-x-sao-os-mais-vendidos-na-olx/</link>
    <comments>https://macmagazine.com.br/post/2021/12/16/iphones-7-8-e-x-sao-os-mais-vendidos-na-olx/#respond</comments>
    <dc:creator>
        <![CDATA[Luiz Gustavo Ribeiro]]>
    </dc:creator>
    <pubDate>Thu, 16 Dec 2021 11:50:27 +0000</pubDate>
    <category>
        <![CDATA[Apple]]>
    </category>
    <category>
        <![CDATA[Gadgets]]>
    </category>
    <category>
        <![CDATA[Telefonia]]>
    </category>
    <category>
        <![CDATA[iPhone]]>
    </category>
    <category>
        <![CDATA[iPhone 11]]>
    </category>
    <category>
        <![CDATA[iPhone 6]]>
    </category>
    <category>
        <![CDATA[iPhone 6s]]>
    </category>
    <category>
        <![CDATA[iPhone 6s Plus]]>
    </category>
    <category>
        <![CDATA[iPhone 7]]>
    </category>
    <category>
        <![CDATA[iPhone 7 Plus]]>
    </category>
    <category>
        <![CDATA[iPhone 8]]>
    </category>
    <category>
        <![CDATA[iPhone 8 Plus]]>
    </category>
    <category>
        <![CDATA[iPhone SE]]>
    </category>
    <category>
        <![CDATA[iPhone X]]>
    </category>
    <category>
        <![CDATA[iPhone XS]]>
    </category>
    <category>
        <![CDATA[levantamento]]>
    </category>
    <category>
        <![CDATA[Mais vendidos]]>
    </category>
    <category>
        <![CDATA[modelos]]>
    </category>
    <category>
        <![CDATA[OLX]]>
    </category>
    <category>
        <![CDATA[Pesquisa]]>
    </category>
    <category>
        <![CDATA[preço médio de venda]]>
    </category>
    <category>
        <![CDATA[premium]]>
    </category>
    <guid isPermaLink="false">https://macmagazine.com.br/?p=841695</guid>
    <description>
        <![CDATA[Um novo levantamento da OLX revelou que os iPhones ocupam o topo em três das quatro categorias dos&#8230;]]>
    </description>
    <content:encoded>
        <![CDATA[<img width="1200" height="675" src="https://macmagazine.com.br/wp-content/uploads/2021/12/16-iPhones-8-X-1260x709.jpg" class="webfeedsFeaturedVisual wp-post-image" alt="iPhones 8 e X" style="display: block; margin: auto; margin-bottom: 5px;max-width: 100%;" link_thumbnail="" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/16-iPhones-8-X-1260x709.jpg 1260w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-iPhones-8-X-600x337.jpg 600w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-iPhones-8-X-300x169.jpg 300w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-iPhones-8-X-1536x864.jpg 1536w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-iPhones-8-X-2048x1152.jpg 2048w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-iPhones-8-X-380x214.jpg 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-iPhones-8-X-800x450.jpg 800w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-iPhones-8-X-1160x652.jpg 1160w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-iPhones-8-X.jpg 3000w" sizes="(max-width: 1200px) 100vw, 1200px" /><p>Um novo levantamento da <strong>OLX</strong> revelou que os<strong>iPhones</strong> ocupam o topo em três das quatro categorias dos dispositivos mais vendidos na plataforma — como visto em outra pesquisa<a href="https://macmagazine.com.br/post/2021/11/05/iphones-dominam-lista-dos-celulares-mais-vendidos-na-olx/">divulgada pelo serviço de vendas no mês passado</a>.</p><p>De acordo com a pesquisa, que divide os aparelhos mais vendidos por faixas de preço, o <strong>iPhone 7</strong> lidera as vendas entre os modelos que custam até R$1 mil; já o<strong>iPhone 8</strong> é o líder em vendas de aparelhos até R$1,5 mil e, na categoria premium — com preço médio de venda até R$2 mil — quem comanda é o<strong>iPhone X</strong>.</p><p>Vale notar que o preço médio de venda levantado pela OLX não significa que todos os anúncios de determinado modelo terão aquele valor, já que cada anunciante estipula seu próprio preço.</p><h3>Mais vendidos até R$500</h3><ol class="is-style-cnvs-list-styled"><li>Samsung Galaxy A10 (preço médio de R$330);</li><li><strong>iPhone 6 (preço médio de R$361)</strong>;</li><li>Moto G7 Play (preço médio de R$319);</li><li><strong>iPhone 6s (preço médio de R$387)</strong>;</li><li>Samsung Galaxy A20 (preço médio de R$370).</li></ol><h3>Mais vendidos até R$1 mil</h3><ol class="is-style-cnvs-list-styled"><li><strong>iPhone 7 (preço médio de R$804)</strong>;</li><li><strong>iPhone 7 Plus (preço médio de R$888)</strong>;</li><li>Redmi Note 8 (preço médio de R$773);</li><li><strong>iPhone 6s Plus (preço médio de R$774)</strong>;</li><li>Samsung Galaxy A50 (preço médio de R$693).</li></ol><h3>Mais vendidos até R$1,5 mil</h3><ol class="is-style-cnvs-list-styled"><li><strong>iPhone 8 (preço médio de R$1.332)</strong>;</li><li><strong>iPhone 8 Plus (preço médio de R$1.337)</strong>;</li><li>Samsung Galaxy A71 (preço médio de R$1.289);</li><li>Redmi Note 10 (preço médio de R$1.349);</li><li>Samsung Galaxy A32 (preço médio de R$1.273).</li></ol><h3> Modelos Premium</h3><ol class="is-style-cnvs-list-styled"><li><strong>iPhone X (preço médio de R$1.389)</strong>;</li><li><strong>iPhone XS (preço médio de R$1.869)</strong>;</li><li><strong>iPhone 11 (preço médio de R$1.749)</strong>;</li><li>Samsung Galaxy S20 (preço médio de R$1.815);</li><li><strong>iPhone SE (preço médio de R$1.828)</strong>.</li></ol><p>Outro dado que surpreende é o iPhone 6 estar em segundo lugar entre os aparelhos mais vendidos até R$500 — o dispositivo, lançado em 2014, tem suporte até o iOS 12.5.5, ainda assim muitos usuários têm interesse no modelo.</p><p>Alguém aí pensando em adquirir algum dos smartphones acima?</p><hr><div class="appbox"><div class="appbox-icon"><a href="https://apple.sjv.io/RybOMN"><img width="424" height="600" src="https://macmagazine.com.br/wp-content/uploads/2021/09/14-iphones-13-pro-13-pro-max-miniatura-424x600.png" alt="Miniatura dos iPhones 13 Pro e 13 Pro Max" class="wp-image-818005" srcset="https://macmagazine.com.br/wp-content/uploads/2021/09/14-iphones-13-pro-13-pro-max-miniatura-424x600.png 424w, https://macmagazine.com.br/wp-content/uploads/2021/09/14-iphones-13-pro-13-pro-max-miniatura-212x300.png 212w, https://macmagazine.com.br/wp-content/uploads/2021/09/14-iphones-13-pro-13-pro-max-miniatura-380x537.png 380w, https://macmagazine.com.br/wp-content/uploads/2021/09/14-iphones-13-pro-13-pro-max-miniatura.png 628w" sizes="(max-width: 424px) 100vw, 424px" /></a></div><div class="appbox-details"><span class="appbox-name"><a href="https://apple.sjv.io/RybOMN">iPhones 13 Pro e 13 Pro Max</a></span><span class="appbox-de">de <strong>Apple</strong></span><span><small><strong>Preço à vista:</strong> a partir de R$8.549,10<br><strong>Preço parcelado:</strong> em até 12x de R$791,58<br><strong>Cores:</strong> azul-sierra, prateada, dourada ou grafite<br><strong>Capacidades:</strong> 128GB, 256GB, 512GB ou 1TB<br><strong>Lançamento:</strong> setembro de 2021</small></span></div><div class="appbox-badge"><span style="float: right;"><a href="https://apple.sjv.io/RybOMN" class="botaoComprar">Comprar</a></span></div></div><hr><div class="appbox"><div class="appbox-icon"><a href="https://apple.sjv.io/doG9Bk"><img width="388" height="600" src="https://macmagazine.com.br/wp-content/uploads/2021/09/14-iphones-13-13-mini-miniatura-388x600.jpeg" alt="Miniatura dos iPhones 13 e 13 mini" class="wp-image-817994" srcset="https://macmagazine.com.br/wp-content/uploads/2021/09/14-iphones-13-13-mini-miniatura-388x600.jpeg 388w, https://macmagazine.com.br/wp-content/uploads/2021/09/14-iphones-13-13-mini-miniatura-194x300.jpeg 194w, https://macmagazine.com.br/wp-content/uploads/2021/09/14-iphones-13-13-mini-miniatura-380x587.jpeg 380w, https://macmagazine.com.br/wp-content/uploads/2021/09/14-iphones-13-13-mini-miniatura.jpeg 528w" sizes="(max-width: 388px) 100vw, 388px" /></a></div><div class="appbox-details"><span class="appbox-name"><a href="https://apple.sjv.io/doG9Bk">iPhones 13 e 13 mini</a></span><span class="appbox-de">de <strong>Apple</strong></span><span><small><strong>Preço à vista:</strong> a partir de R$5.939,10<br><strong>Preço parcelado:</strong> em até 12x de R$549,92<br><strong>Cores:</strong> rosa, azul, meia-noite, estelar ou (PRODUCT)RED<br><strong>Capacidades:</strong> 128GB, 256GB ou 512GB<br><strong>Lançamento:</strong> setembro de 2021</small></span></div><div class="appbox-badge"><span style="float: right;"><a href="https://apple.sjv.io/doG9Bk" class="botaoComprar">Comprar</a></span></div></div><hr><div class="appbox"><div class="appbox-icon"><a href="https://apple.sjv.io/EvM49"><img width="579" height="600" src="https://macmagazine.com.br/wp-content/uploads/2021/01/22-iphone-11-miniatura-579x600.jpeg" alt="iPhone 11 (miniatura)" class="wp-image-760576" srcset="https://macmagazine.com.br/wp-content/uploads/2021/01/22-iphone-11-miniatura-579x600.jpeg 579w, https://macmagazine.com.br/wp-content/uploads/2021/01/22-iphone-11-miniatura-289x300.jpeg 289w, https://macmagazine.com.br/wp-content/uploads/2021/01/22-iphone-11-miniatura.jpeg 880w" sizes="(max-width: 579px) 100vw, 579px" /></a></div><div class="appbox-details"><span class="appbox-name"><a href="https://apple.sjv.io/EvM49">iPhone 11</a></span><span class="appbox-de">de <strong>Apple</strong></span><span><small><strong>Preço à vista:</strong> a partir de R$5.129,10<br><strong>Preço parcelado:</strong> em até 12x de R$474,92<br><strong>Cores:</strong> branca, preta, verde, amarela, roxa e (PRODUCT)RED<br><strong>Capacidades:</strong> 64GB, 128GB ou 256GB<br><strong>Lançamento:</strong> setembro de 2019</small></span></div><div class="appbox-badge"><span style="float: right;"><a href="https://apple.sjv.io/EvM49" class="botaoComprar">Comprar</a></span></div></div><hr><div class="appbox"><div class="appbox-icon"><a href="https://apple.sjv.io/kAg20"><img src="https://macmagazine.com.br/wp-content/uploads/2018/11/09-iphone-xr-600x375.png" alt="iPhone XR em pé" class="alignnone size-medium wp-image-647339" width="600" height="375" srcset="https://macmagazine.com.br/wp-content/uploads/2018/11/09-iphone-xr-600x375.png 600w, https://macmagazine.com.br/wp-content/uploads/2018/11/09-iphone-xr-300x188.png 300w, https://macmagazine.com.br/wp-content/uploads/2018/11/09-iphone-xr-1260x788.png 1260w, https://macmagazine.com.br/wp-content/uploads/2018/11/09-iphone-xr.png 1501w" sizes="(max-width: 600px) 100vw, 600px" /></a></div><div class="appbox-details"><span class="appbox-name"><a href="https://apple.sjv.io/kAg20">iPhone XR</a></span><span class="appbox-de">de <strong>Apple</strong></span><span><small><strong>Preço à vista:</strong> a partir de R$4.499,10<br><strong>Preço parcelado:</strong> em até 12x de R$416,58<br><strong>Cores:</strong> branca, preta, azul, amarela, coral e (PRODUCT)RED<br><strong>Capacidades:</strong> 64GB e 128GB<br><strong>Lançamento:</strong> setembro de 2018</small></span></div><div class="appbox-badge"><span style="float: right;"><a href="https://apple.sjv.io/kAg20" class="botaoComprar">Comprar</a></span></div></div><hr><div class="appbox"><div class="appbox-icon"><a href="https://apple.sjv.io/5rAWN"><img width="499" height="600" src="https://macmagazine.com.br/wp-content/uploads/2020/04/28-iphone-se-499x600.jpeg" alt="iPhone SE" class="wp-image-719935" srcset="https://macmagazine.com.br/wp-content/uploads/2020/04/28-iphone-se-499x600.jpeg 499w, https://macmagazine.com.br/wp-content/uploads/2020/04/28-iphone-se-249x300.jpeg 249w, https://macmagazine.com.br/wp-content/uploads/2020/04/28-iphone-se.jpeg 632w" sizes="(max-width: 499px) 100vw, 499px" /></a></div><div class="appbox-details"><span class="appbox-name"><a href="https://apple.sjv.io/5rAWN">iPhone SE</a></span><span class="appbox-de">de <strong>Apple</strong></span><span><small><strong>Preço à vista:</strong> a partir de R$3.329,10<br><strong>Preço parcelado:</strong> em até 12x de R$308,25<br><strong>Cores:</strong> preta, branca ou (PRODUCT)RED<br><strong>Capacidades:</strong> 64GB, 128GB ou 256GB<br><strong>Lançamento:</strong> abril de 2020</small></span></div><div class="appbox-badge"><span style="float: right;"><a href="https://apple.sjv.io/5rAWN" class="botaoComprar">Comprar</a></span></div></div><p class="notaTransparencia">NOTA DE TRANSPARÊNCIA: O <strong><em>MacMagazine</em></strong> recebe uma pequena comissão de vendas concluídas por meio de links deste post, mas você, como consumidor, não paga nada mais pelos produtos comprando pelos nossos links de afiliado.</p><p><span class="credito">via <a href="https://www.tecmundo.com.br/mercado/230461-iphone-domina-lista-aparelhos-vendidos-buscados-olx.htm">TecMundo</a></span></p>
]]>
</content:encoded>
<wfw:commentRss>https://macmagazine.com.br/post/2021/12/16/iphones-7-8-e-x-sao-os-mais-vendidos-na-olx/feed/</wfw:commentRss>
<slash:comments>0</slash:comments>
<post-id xmlns="com-wordpress:feed-additions:1">841695</post-id>
<media:content xmlns:media="http://search.yahoo.com/mrss/" medium="image" type="image/jpeg" url="https://macmagazine.com.br/wp-content/uploads/2021/12/16-iPhones-8-X-1260x709.jpg" width="1200" height="675" />
</item>
<item>
    <title>Pesquisadores revelam detalhes por trás dos ataques do NSO Group</title>
    <link>https://macmagazine.com.br/post/2021/12/16/pesquisadores-revelam-detalhes-por-tras-dos-ataques-do-nso-group/</link>
    <comments>https://macmagazine.com.br/post/2021/12/16/pesquisadores-revelam-detalhes-por-tras-dos-ataques-do-nso-group/#respond</comments>
    <dc:creator>
        <![CDATA[Diogo Ammon]]>
    </dc:creator>
    <pubDate>Thu, 16 Dec 2021 11:30:00 +0000</pubDate>
    <category>
        <![CDATA[Internet]]>
    </category>
    <category>
        <![CDATA[Segurança]]>
    </category>
    <category>
        <![CDATA[Software]]>
    </category>
    <category>
        <![CDATA[Apple]]>
    </category>
    <category>
        <![CDATA[Ataques]]>
    </category>
    <category>
        <![CDATA[exploits]]>
    </category>
    <category>
        <![CDATA[FORCEDENTRY]]>
    </category>
    <category>
        <![CDATA[iMessage]]>
    </category>
    <category>
        <![CDATA[invasão]]>
    </category>
    <category>
        <![CDATA[iPhones]]>
    </category>
    <category>
        <![CDATA[NSO Group]]>
    </category>
    <category>
        <![CDATA[Pegasus]]>
    </category>
    <category>
        <![CDATA[pesquisadores]]>
    </category>
    <category>
        <![CDATA[privacidade]]>
    </category>
    <category>
        <![CDATA[Project Zero]]>
    </category>
    <category>
        <![CDATA[Sistema]]>
    </category>
    <category>
        <![CDATA[Spyware]]>
    </category>
    <category>
        <![CDATA[zero-click]]>
    </category>
    <guid isPermaLink="false">https://macmagazine.com.br/?p=841630</guid>
    <description>
        <![CDATA[Já falamos diversas vezes sobre o NSO Group, criador do Pegasus — spyware utilizado para invadir dispositivos ilegal&#8230;]]>
    </description>
    <content:encoded>
        <![CDATA[<img width="1200" height="800" src="https://macmagazine.com.br/wp-content/uploads/2021/12/03-NSO-Apple-logo-1260x840.jpg" class="webfeedsFeaturedVisual wp-post-image" alt="Logo do NSO Group e da Apple" style="display: block; margin: auto; margin-bottom: 5px;max-width: 100%;" link_thumbnail="" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/03-NSO-Apple-logo-1260x840.jpg 1260w, https://macmagazine.com.br/wp-content/uploads/2021/12/03-NSO-Apple-logo-600x400.jpg 600w, https://macmagazine.com.br/wp-content/uploads/2021/12/03-NSO-Apple-logo-300x200.jpg 300w, https://macmagazine.com.br/wp-content/uploads/2021/12/03-NSO-Apple-logo-1536x1024.jpg 1536w, https://macmagazine.com.br/wp-content/uploads/2021/12/03-NSO-Apple-logo-2048x1366.jpg 2048w, https://macmagazine.com.br/wp-content/uploads/2021/12/03-NSO-Apple-logo-380x253.jpg 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/03-NSO-Apple-logo-800x533.jpg 800w, https://macmagazine.com.br/wp-content/uploads/2021/12/03-NSO-Apple-logo-1160x773.jpg 1160w" sizes="(max-width: 1200px) 100vw, 1200px" /><p>Já falamos diversas vezes <a href="https://macmagazine.com.br/sobre/nso-group/">sobre o <strong>NSO Group</strong></a>, criador do <strong><a href="https://macmagazine.com.br/sobre/pegasus/">Pegasus</a></strong> — <em>spyware</em> utilizado para invadir dispositivos ilegal e silenciosamente.</p><p>Recentemente, <a href="https://googleprojectzero.blogspot.com/2021/12/a-deep-dive-into-nso-zero-click.html">pesquisadores de segurança do <strong>Google</strong> mergulharam profundamente</a> no no <a href="https://macmagazine.com.br/post/2021/07/19/imessage-e-vulneravel-a-spyware-israelense-no-ios-14-6/"><em>exploit zero-click</em> do iMessage</a> (já corrigido pela Apple), utilizado pelo NSO, e descobriram ainda mais informações por trás da sua sofisticada e assustadora operação da forma.</p><p>De acordo com pesquisadores do <strong>Project Zero</strong>, o<em>exploit zero-click</em><strong>ForcedEntry</strong> — o qual foi utilizado para atingir ativistas e jornalistas — é um dos mais sofisticados tecnicamente já vistos por eles.</p><p>A coisa é tão elaborada que o NSO conseguia atingir usuários apenas pelo fato de estarem usando o iMessage — se utilizando de uma vulnerabilidade no sistema de decodificação de arquivos GIF do mensageiro. Por meio desse processo, o <em>spyware</em> conseguia enganar a plataforma para abrir diversos PDFs maliciosos sem qualquer interação do usuário — obtendo, depois, controle total do aparelho.</p><p>A vulnerabilidade, em particular, estava relacionada a uma antiga ferramenta de compressão utilizada pela Apple para reconhecer textos em fotos. O método de infecção do ForcedEntry era tão engenhoso que, para evitar ser detectado, virtualizava seus comandos em um ambiente virtual em vez de comunicá-los a um servidor.</p><p>Até onde se sabe, esses tipos de ataques já foram utilizados diversas vezes contra ativistas, jornalistas e políticos — tanto é que o NSO entrou para a lista de <a href="https://macmagazine.com.br/post/2021/11/04/criadora-do-spyware-pegasus-esta-na-lista-de-ameacas-dos-eua/">ameaças de segurança nacional dos Estados Unidos</a>.</p><p>Em novembro último, a Apple iniciou um processo contra o NSO Group <a href="https://macmagazine.com.br/post/2021/11/23/apple-processa-nso-group-por-ataques-com-spyware-pegasus/">para que eles fossem responsabilizados por ataques a iPhones</a>. Mais recentemente, seja relacionado a isso ou não, fontes indicam que a empresa estaria tentando limpar a sua imagem e estaria<a href="https://macmagazine.com.br/post/2021/12/14/nso-group-podera-encerrar-atividades-com-spyware-pegasus/">disposta a encerrar as atividades do <em>spyware</em> Pegasus</a>.</p>
]]>
</content:encoded>
<wfw:commentRss>https://macmagazine.com.br/post/2021/12/16/pesquisadores-revelam-detalhes-por-tras-dos-ataques-do-nso-group/feed/</wfw:commentRss>
<slash:comments>0</slash:comments>
<post-id xmlns="com-wordpress:feed-additions:1">841630</post-id>
<media:content xmlns:media="http://search.yahoo.com/mrss/" medium="image" type="image/jpeg" url="https://macmagazine.com.br/wp-content/uploads/2021/12/03-NSO-Apple-logo-1260x840.jpg" width="1200" height="800" />
</item>
<item>
    <title>Instagram testa vídeos de até 60 segundos nos Stories</title>
    <link>https://macmagazine.com.br/post/2021/12/16/instagram-testa-videos-de-ate-60-segundos-nos-stories/</link>
    <comments>https://macmagazine.com.br/post/2021/12/16/instagram-testa-videos-de-ate-60-segundos-nos-stories/#respond</comments>
    <dc:creator>
        <![CDATA[Diogo Ammon]]>
    </dc:creator>
    <pubDate>Thu, 16 Dec 2021 11:00:00 +0000</pubDate>
    <category>
        <![CDATA[Internet]]>
    </category>
    <category>
        <![CDATA[Software]]>
    </category>
    <category>
        <![CDATA[Vídeos]]>
    </category>
    <category>
        <![CDATA[60 segundos]]>
    </category>
    <category>
        <![CDATA[Facebook]]>
    </category>
    <category>
        <![CDATA[Instagram]]>
    </category>
    <category>
        <![CDATA[Instagram Stories]]>
    </category>
    <category>
        <![CDATA[meta]]>
    </category>
    <category>
        <![CDATA[novidade]]>
    </category>
    <category>
        <![CDATA[rede]]>
    </category>
    <category>
        <![CDATA[rede social]]>
    </category>
    <category>
        <![CDATA[Stories]]>
    </category>
    <category>
        <![CDATA[testes]]>
    </category>
    <category>
        <![CDATA[usuários]]>
    </category>
    <category>
        <![CDATA[vídeos mais longos]]>
    </category>
    <guid isPermaLink="false">https://macmagazine.com.br/?p=841644</guid>
    <description>
        <![CDATA[O Instagram já estava testando a função com alguns usuários, mas parece que a rede finalmente começará a&#8230;]]>
    </description>
    <content:encoded>
        <![CDATA[<img width="1200" height="800" src="https://macmagazine.com.br/wp-content/uploads/2021/12/15-instagram-1260x840.jpg" class="webfeedsFeaturedVisual wp-post-image" alt="Instagram" style="display: block; margin: auto; margin-bottom: 5px;max-width: 100%;" link_thumbnail="" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/15-instagram-1260x840.jpg 1260w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-instagram-600x400.jpg 600w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-instagram-300x200.jpg 300w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-instagram-1536x1024.jpg 1536w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-instagram-2048x1365.jpg 2048w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-instagram-380x253.jpg 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-instagram-800x533.jpg 800w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-instagram-1160x773.jpg 1160w" sizes="(max-width: 1200px) 100vw, 1200px" /><p>O <strong>Instagram</strong> já estava testando a função com alguns usuários, mas parece que a rede finalmente começará a permitir a postagem de vídeos mais longos — de até 60 segundos — nos<em><strong>Stories</strong></em>.</p><p>Até agora, esse limite é de 15 segundos. Como de costume, vídeos mais longos do que isso são seccionados em diversas partes.</p><p>A novidade foi descoberta por um usuário da rede da Turquia e noticiada pelo <em>insider</em><strong>Matt Navarra</strong>:</p><figure class="wp-block-embed aligncenter is-type-rich is-provider-twitter wp-block-embed-twitter"><div class="wp-block-embed__wrapper"><blockquote class="twitter-tweet" data-width="550" data-dnt="true"><p lang="en" dir="ltr">Instagram is testing longer stories segments of up-to 60 seconds <br><br>Spotted by <a href="https://twitter.com/yousufortaccom?ref_src=twsrc%5Etfw">@yousufortaccom</a> in Turkey<a href="https://t.co/6LJ2Rjqbpz">pic.twitter.com/6LJ2Rjqbpz</a></p>&mdash; Matt Navarra (@MattNavarra) <a href="https://twitter.com/MattNavarra/status/1471199503076274185?ref_src=twsrc%5Etfw">December 15, 2021</a></blockquote><script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script></div><figcaption>O Instagram está testando segmentos de histórias mais longas de até 60 segundos</figcaption></figure><p>O app começou a notificar alguns usuários sobre a mudança recentemente, mas não se sabe ao certo quando o recurso estará de fato liberado para todos os usuários.</p><p>E aí, o aviso já apareceu no seu aplicativo?</p><hr /><div class="appbox"><div class="appbox-icon"><a href="https://apps.apple.com/br/app/instagram/id389801252" target="_blank"><img class="appbox-iconiOS" alt="&Iacute;cone do app Instagram" src="https://is5-ssl.mzstatic.com/image/thumb/Purple116/v4/ed/56/c2/ed56c249-8f1c-10c5-af47-7ccac7fdec29/Prod-0-0-1x_U007emarketing-0-0-0-7-0-0-sRGB-0-0-0-GLES2_U002c0-512MB-85-220-0-0.png/256x256bb.png" /></a></div><div class="appbox-details"><span class="appbox-name"><a href="https://apps.apple.com/br/app/instagram/id389801252" target="_blank">Instagram</a></span><span class="appbox-de">de <strong><a href="http://instagram.com/" target="_blank" class="no_icon" rel="nofollow">Instagram, Inc.</a></strong></span><div class="appbox-devices"><img src="https://macmagazine.com.br/wp-content/uploads/2015/11/devices_iphone.png" alt="Compat&iacute;vel com iPhones" title="Compat&iacute;vel com iPhones" class="appbox-devicesiPhone" /></div><div class="appbox-info">Vers&atilde;o <strong>216.0</strong> (197.5 MB)<br />
                    Requer o <strong>iOS 12.0</strong> ou superior</div></div><div class="appbox-badge"><span class="appbox-price">Gr&aacute;tis</span><span><a href="https://apps.apple.com/br/app/instagram/id389801252" target="_blank"><img alt="Badge - Baixar na App Store" src="https://macmagazine.com.br/wp-content/uploads/2017/11/22-badge_appstore.png" class="badgeInvert" /></a></span><span class="appbox-QRcode"><a href="javascript:void(0);" title="C&oacute;digo QR - Instagram" onclick="javascript:abrirQR('https://chart.googleapis.com/chart?chs=400x400&cht=qr&chl=https%3A%2F%2Fapps.apple.com%2Fbr%2Fapp%2Finstagram%2Fid389801252&chld=L|0');return false;"><img alt="C&oacute;digo QR" src="https://macmagazine.com.br/wp-content/themes/newsblock-child/images/qr.png" /></a><a href="javascript:void(0);" title="C&oacute;digo QR - Instagram" onclick="javascript:abrirQR('https://chart.googleapis.com/chart?chs=400x400&cht=qr&chl=https%3A%2F%2Fapps.apple.com%2Fbr%2Fapp%2Finstagram%2Fid389801252&chld=L|0');return false;">C&oacute;digo QR</a></span></div>
                </div>
]]>
</content:encoded>
<wfw:commentRss>https://macmagazine.com.br/post/2021/12/16/instagram-testa-videos-de-ate-60-segundos-nos-stories/feed/</wfw:commentRss>
<slash:comments>0</slash:comments>
<post-id xmlns="com-wordpress:feed-additions:1">841644</post-id>
<media:content xmlns:media="http://search.yahoo.com/mrss/" medium="image" type="image/jpeg" url="https://macmagazine.com.br/wp-content/uploads/2021/12/15-instagram-1260x840.jpg" width="1200" height="800" />
</item>
<item>
    <title>Como ouvir um áudio antes de enviar pelo WhatsApp [iPhone]</title>
    <link>https://macmagazine.com.br/post/2021/12/16/como-ouvir-um-audio-antes-de-enviar-pelo-whatsapp-iphone/</link>
    <comments>https://macmagazine.com.br/post/2021/12/16/como-ouvir-um-audio-antes-de-enviar-pelo-whatsapp-iphone/#respond</comments>
    <dc:creator>
        <![CDATA[Pedro Henrique Nunes]]>
    </dc:creator>
    <pubDate>Thu, 16 Dec 2021 10:40:00 +0000</pubDate>
    <category>
        <![CDATA[Dicas]]>
    </category>
    <category>
        <![CDATA[Software]]>
    </category>
    <category>
        <![CDATA[Tutoriais]]>
    </category>
    <category>
        <![CDATA[áudio]]>
    </category>
    <category>
        <![CDATA[dica]]>
    </category>
    <category>
        <![CDATA[iPhone]]>
    </category>
    <category>
        <![CDATA[mensageiro]]>
    </category>
    <category>
        <![CDATA[mensageiro instantâneo]]>
    </category>
    <category>
        <![CDATA[mensagens de áudio]]>
    </category>
    <category>
        <![CDATA[mensagens de voz]]>
    </category>
    <category>
        <![CDATA[tutorial]]>
    </category>
    <category>
        <![CDATA[WhatsApp]]>
    </category>
    <category>
        <![CDATA[WhatsApp Messenger]]>
    </category>
    <guid isPermaLink="false">https://macmagazine.com.br/?p=841475</guid>
    <description>
        <![CDATA[Conforme já noticiamos por aqui, o WhatsApp Messenger finalmente começou a liberar uma atualização que permite ouvir os&#8230;]]>
    </description>
    <content:encoded>
        <![CDATA[<img width="1200" height="800" src="https://macmagazine.com.br/wp-content/uploads/2021/05/07-whatsapp-2-1260x840.jpg" class="webfeedsFeaturedVisual wp-post-image" alt="WhatsApp" style="display: block; margin: auto; margin-bottom: 5px;max-width: 100%;" link_thumbnail="" srcset="https://macmagazine.com.br/wp-content/uploads/2021/05/07-whatsapp-2-1260x840.jpg 1260w, https://macmagazine.com.br/wp-content/uploads/2021/05/07-whatsapp-2-600x400.jpg 600w, https://macmagazine.com.br/wp-content/uploads/2021/05/07-whatsapp-2-300x200.jpg 300w, https://macmagazine.com.br/wp-content/uploads/2021/05/07-whatsapp-2-1536x1024.jpg 1536w, https://macmagazine.com.br/wp-content/uploads/2021/05/07-whatsapp-2-2048x1365.jpg 2048w, https://macmagazine.com.br/wp-content/uploads/2021/05/07-whatsapp-2-380x253.jpg 380w, https://macmagazine.com.br/wp-content/uploads/2021/05/07-whatsapp-2-800x533.jpg 800w, https://macmagazine.com.br/wp-content/uploads/2021/05/07-whatsapp-2-1160x773.jpg 1160w" sizes="(max-width: 1200px) 100vw, 1200px" /><p>Conforme já <a href="https://macmagazine.com.br/post/2021/12/15/whatsapp-ja-permite-ouvir-audios-antes-de-envia-los/">noticiamos por aqui</a>, o<strong>WhatsApp Messenger</strong> finalmente começou a liberar uma atualização que permite ouvir os áudios antes de enviá-los a um contato ou grupo.</p><p>Há um tempo, até mostramos como você poderia fazer isso usando uma <a href="https://macmagazine.com.br/post/2021/05/31/como-ouvir-um-audio-antes-de-envia-lo-no-whatsapp/">gambiarra muito simples</a>, mas agora é possível fazer isso &#8220;oficialmente&#8221;, de uma forma muito mais simples e eficaz.</p><div class="wp-block-group posts-relacionados"><div class="wp-block-group__inner-container"><p><b>Posts relacionados</b></p><ul><li><a href="https://macmagazine.com.br/post/2021/12/14/video-dicas-para-voce-economizar-espaco-no-whatsapp/">Vídeo: dicas para você economizar espaço no WhatsApp!</a></li><li><a href="https://macmagazine.com.br/post/2021/12/13/como-editar-fotos-videos-pelo-whatsapp-iphone-mac-e-web/">Como editar fotos/vídeos pelo WhatsApp [iPhone, Mac e web]</a></li><li><a href="https://macmagazine.com.br/post/2021/12/13/como-fixar-mensagens-no-whatsapp-iphone-mac-e-web/">Como fixar mensagens no WhatsApp [iPhone, Mac e web]</a></li></ul></div></div><p>Assim, fica fácil cancelar o envio caso você se arrependa de alguma coisa que tenha dito, da forma como tudo foi falado ou simplesmente não queira mais mandar a mensagem para uma pessoa ou um grupo no mensageiro depois de escutá-la. <img src="https://s.w.org/images/core/emoji/13.1.0/72x72/1f61b.png" alt="😛" class="wp-smiley" style="height: 1em; max-height: 1em;" /></p><p>Veja só como é simples fazer isso: pelo iPhone, abra o WhatsApp e selecione a conversa individual ou o grupo para o qual deseja enviar a mensagem de áudio. </p><p>Em seguida, pressione e segure o dedo sobre o ícone de microfone e arraste-o para cima (o que o WhatsApp chama de gravação com as mãos livres). Comece a falar para que o áudio seja capturado e, quando estiver satisfeito, toque no botão vermelho de parar (<em>stop</em>) a gravação.</p><div class="wp-block-image"><figure class="aligncenter size-large"><a href="https://macmagazine.com.br/wp-content/uploads/2021/12/15-ouvir-audio-whatsapp.png"><img width="1260" height="817" src="https://macmagazine.com.br/wp-content/uploads/2021/12/15-ouvir-audio-whatsapp-1260x817.png" alt="" class="wp-image-841493" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/15-ouvir-audio-whatsapp-1260x817.png 1260w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-ouvir-audio-whatsapp-600x389.png 600w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-ouvir-audio-whatsapp-300x194.png 300w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-ouvir-audio-whatsapp-1536x996.png 1536w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-ouvir-audio-whatsapp-2048x1328.png 2048w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-ouvir-audio-whatsapp-380x246.png 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-ouvir-audio-whatsapp-800x519.png 800w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-ouvir-audio-whatsapp-1160x752.png 1160w" sizes="(max-width: 1260px) 100vw, 1260px" /></a></figure></div><p>Depois, toque no botão de reproduzir <meta charset="utf-8">para ouvir o áudio. Caso queira apagá-lo, toque no ícone de lixeira ou, se estiver satisfeito e quiser enviá-lo, toque no botão com a seta azul. </p><p>Muito bom! <img src="https://s.w.org/images/core/emoji/13.1.0/72x72/1f399.png" alt="🎙" class="wp-smiley" style="height: 1em; max-height: 1em;" /><img src="https://s.w.org/images/core/emoji/13.1.0/72x72/1f4f1.png" alt="📱" class="wp-smiley" style="height: 1em; max-height: 1em;" /></p><hr /><div class="appbox"><div class="appbox-icon"><a href="https://apps.apple.com/br/app/whatsapp-messenger/id310633997" target="_blank"><img class="appbox-iconiOS" alt="&Iacute;cone do app WhatsApp Messenger" src="https://is4-ssl.mzstatic.com/image/thumb/Purple126/v4/9d/3f/bf/9d3fbfad-11ca-1781-d7c1-508959f40003/AppIcon-0-0-1x_U007emarketing-0-0-0-6-0-0-sRGB-0-0-0-GLES2_U002c0-512MB-85-220-0-0.png/256x256bb.png" /></a></div><div class="appbox-details"><span class="appbox-name"><a href="https://apps.apple.com/br/app/whatsapp-messenger/id310633997" target="_blank">WhatsApp Messenger</a></span><span class="appbox-de">de <strong><a href="http://www.whatsapp.com/" target="_blank" class="no_icon" rel="nofollow">WhatsApp Inc.</a></strong></span><div class="appbox-devices"><img src="https://macmagazine.com.br/wp-content/uploads/2015/11/devices_iphone.png" alt="Compat&iacute;vel com iPhones" title="Compat&iacute;vel com iPhones" class="appbox-devicesiPhone" /></div><div class="appbox-info">Vers&atilde;o <strong>2.21.241</strong> (204 MB)<br />
                    Requer o <strong>iOS 10.0</strong> ou superior</div></div><div class="appbox-badge"><span class="appbox-price">Gr&aacute;tis</span><span><a href="https://apps.apple.com/br/app/whatsapp-messenger/id310633997" target="_blank"><img alt="Badge - Baixar na App Store" src="https://macmagazine.com.br/wp-content/uploads/2017/11/22-badge_appstore.png" class="badgeInvert" /></a></span><span class="appbox-QRcode"><a href="javascript:void(0);" title="C&oacute;digo QR - WhatsApp Messenger" onclick="javascript:abrirQR('https://chart.googleapis.com/chart?chs=400x400&cht=qr&chl=https%3A%2F%2Fapps.apple.com%2Fbr%2Fapp%2Fwhatsapp-messenger%2Fid310633997&chld=L|0');return false;"><img alt="C&oacute;digo QR" src="https://macmagazine.com.br/wp-content/themes/newsblock-child/images/qr.png" /></a><a href="javascript:void(0);" title="C&oacute;digo QR - WhatsApp Messenger" onclick="javascript:abrirQR('https://chart.googleapis.com/chart?chs=400x400&cht=qr&chl=https%3A%2F%2Fapps.apple.com%2Fbr%2Fapp%2Fwhatsapp-messenger%2Fid310633997&chld=L|0');return false;">C&oacute;digo QR</a></span></div>
                </div>
]]>
</content:encoded>
<wfw:commentRss>https://macmagazine.com.br/post/2021/12/16/como-ouvir-um-audio-antes-de-enviar-pelo-whatsapp-iphone/feed/</wfw:commentRss>
<slash:comments>0</slash:comments>
<post-id xmlns="com-wordpress:feed-additions:1">841475</post-id>
<media:content xmlns:media="http://search.yahoo.com/mrss/" medium="image" type="image/jpeg" url="https://macmagazine.com.br/wp-content/uploads/2021/05/07-whatsapp-2-1260x840.jpg" width="1200" height="800" />
</item>
<item>
    <title>Como abrir todos os sites de uma pasta do favoritos do Safari [iPhone, iPad e Mac]</title>
    <link>https://macmagazine.com.br/post/2021/12/16/como-abrir-todos-os-sites-de-uma-pasta-do-favoritos-do-safari-iphone-ipad-e-mac/</link>
    <comments>https://macmagazine.com.br/post/2021/12/16/como-abrir-todos-os-sites-de-uma-pasta-do-favoritos-do-safari-iphone-ipad-e-mac/#respond</comments>
    <dc:creator>
        <![CDATA[Pedro Henrique Nunes]]>
    </dc:creator>
    <pubDate>Thu, 16 Dec 2021 10:15:00 +0000</pubDate>
    <category>
        <![CDATA[Apple]]>
    </category>
    <category>
        <![CDATA[Dicas]]>
    </category>
    <category>
        <![CDATA[Internet]]>
    </category>
    <category>
        <![CDATA[Mac]]>
    </category>
    <category>
        <![CDATA[Tutoriais]]>
    </category>
    <category>
        <![CDATA[Abas]]>
    </category>
    <category>
        <![CDATA[dica]]>
    </category>
    <category>
        <![CDATA[favoritos]]>
    </category>
    <category>
        <![CDATA[iOS]]>
    </category>
    <category>
        <![CDATA[iPad]]>
    </category>
    <category>
        <![CDATA[iPadOS]]>
    </category>
    <category>
        <![CDATA[iPhone]]>
    </category>
    <category>
        <![CDATA[macOS]]>
    </category>
    <category>
        <![CDATA[navegador]]>
    </category>
    <category>
        <![CDATA[pastas de favoritos]]>
    </category>
    <category>
        <![CDATA[Safari]]>
    </category>
    <category>
        <![CDATA[tutorial]]>
    </category>
    <guid isPermaLink="false">https://macmagazine.com.br/?p=841420</guid>
    <description>
        <![CDATA[O Safari muito provavelmente é o navegador mais usado por usuários de iPhones/iPads e Macs. Afinal de contas,&#8230;]]>
    </description>
    <content:encoded>
        <![CDATA[<img width="1200" height="526" src="https://macmagazine.com.br/wp-content/uploads/2021/02/23-safari-1260x552.png" class="webfeedsFeaturedVisual wp-post-image" alt="Safari" style="display: block; margin: auto; margin-bottom: 5px;max-width: 100%;" link_thumbnail="" srcset="https://macmagazine.com.br/wp-content/uploads/2021/02/23-safari-1260x552.png 1260w, https://macmagazine.com.br/wp-content/uploads/2021/02/23-safari-600x263.png 600w, https://macmagazine.com.br/wp-content/uploads/2021/02/23-safari-300x131.png 300w, https://macmagazine.com.br/wp-content/uploads/2021/02/23-safari-1536x673.png 1536w, https://macmagazine.com.br/wp-content/uploads/2021/02/23-safari-2048x897.png 2048w, https://macmagazine.com.br/wp-content/uploads/2021/02/23-safari-380x166.png 380w, https://macmagazine.com.br/wp-content/uploads/2021/02/23-safari-800x350.png 800w, https://macmagazine.com.br/wp-content/uploads/2021/02/23-safari-1160x508.png 1160w, https://macmagazine.com.br/wp-content/uploads/2021/02/23-safari.png 2743w" sizes="(max-width: 1200px) 100vw, 1200px" /><p>O <strong>Safari</strong> muito provavelmente é o navegador mais usado por usuários de iPhones/iPads e Macs.</p><p>Afinal de contas, por ele já vir incluído por padrão nos sistemas operacionais da Maçã, não é preciso baixar outro — a não ser que você precise ou <a href="https://macmagazine.com.br/post/2020/12/24/como-alterar-cliente-de-email-e-navegador-padroes-no-ios-14/">prefira outra opção, é claro</a>.</p><div class="wp-block-group posts-relacionados"><div class="wp-block-group__inner-container"><p><b>Posts relacionados</b></p><ul><li><a href="https://macmagazine.com.br/post/2021/01/07/como-adicionar-varias-abas-aos-favoritos-do-safari-em-iphones-e-ipads/">Como adicionar várias abas aos Favoritos do Safari em iPhones e iPads</a></li><li><a href="https://macmagazine.com.br/post/2021/10/02/como-criar-um-grupo-de-abas-no-safari-iphone-ipad-e-mac/">Como criar um Grupo de Abas no Safari [iPhone, iPad e Mac]</a></li><li><a href="https://macmagazine.com.br/post/2021/04/08/como-reabrir-todas-as-abas-da-ultima-sessao-do-safari-de-uma-vez-so-mac/">Como reabrir todas as abas da última sessão do Safari de uma vez só [Mac]</a></li></ul></div></div><p>Para manter os sites que você visita frequentemente — ou aqueles que você quer realmente guardar — organizados, a maneira mais fácil é criar pastas de favoritos, que você pode dividir em categorias como &#8220;Notícias&#8221; e &#8220;Entretenimento&#8221;, para dar alguns poucos exemplos.</p><p>Pois uma opção no Safari permite que você abra, de uma só vez, todos esses sites contidos em uma pasta dos favoritos. Isso é possível não só nos iPhones/iPads, como nos Macs também.</p><h2>Como abrir todos os sites de uma pasta de favoritos no iPhone/iPad</h2><p>Abra o Safari e toque no ícone representado por um livro (no iPhone, ele fica na parte inferior). Em seguida, toque na aba com o mesmo ícone aparente para ver todos os seus favoritos.</p><p>Após localizar a pasta onde os sites que você deseja abrir estão localizados, toque e segure o dedo sobre ela e selecione &#8220;Abrir em Novas Abas&#8221;.</p><div class="wp-block-image"><figure class="aligncenter size-large"><a href="https://macmagazine.com.br/wp-content/uploads/2021/12/15-abrir-abas-favoritos-Safari.png"><img width="1260" height="612" src="https://macmagazine.com.br/wp-content/uploads/2021/12/15-abrir-abas-favoritos-Safari-1260x612.png" alt="" class="wp-image-841435" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/15-abrir-abas-favoritos-Safari-1260x612.png 1260w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-abrir-abas-favoritos-Safari-600x291.png 600w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-abrir-abas-favoritos-Safari-300x146.png 300w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-abrir-abas-favoritos-Safari-1536x745.png 1536w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-abrir-abas-favoritos-Safari-2048x994.png 2048w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-abrir-abas-favoritos-Safari-380x184.png 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-abrir-abas-favoritos-Safari-800x388.png 800w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-abrir-abas-favoritos-Safari-1160x563.png 1160w" sizes="(max-width: 1260px) 100vw, 1260px" /></a></figure></div><p>Com isso, todas elas serão abertas separadamente em novas abas do navegador.</p><h2><meta charset="utf-8">Como abrir todos os sites de uma pasta de favoritos no Mac</h2><p><meta charset="utf-8">Abra o Safari no Mac e clique no botão localizado no canto superior esquerdo, para mostrar a barra lateral, e clique em &#8220;Favoritos&#8221;. Você também pode chegar a essa mesma seção usando o atalho <kbd>⌃</kbd><kbd>⌘</kbd><kbd>1</kbd>.</p><div class="wp-block-image"><figure class="aligncenter size-full"><a href="https://macmagazine.com.br/wp-content/uploads/2021/12/15-abrir-abas-favoritos-safari-mac.png"><img width="1132" height="940" src="https://macmagazine.com.br/wp-content/uploads/2021/12/15-abrir-abas-favoritos-safari-mac.png" alt="Abrir todos os sites de uma pasta de favoritos ao mesmo tempo" class="wp-image-841665" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/15-abrir-abas-favoritos-safari-mac.png 1132w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-abrir-abas-favoritos-safari-mac-600x498.png 600w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-abrir-abas-favoritos-safari-mac-300x249.png 300w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-abrir-abas-favoritos-safari-mac-380x316.png 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-abrir-abas-favoritos-safari-mac-800x664.png 800w" sizes="(max-width: 1132px) 100vw, 1132px" /></a></figure></div><p>Após localizar a pasta de favoritos, clique com o botão direito do mouse sobre ela e selecione &#8220;Abrir em Novas Abas&#8221;.</p><hr class="wp-block-separator is-style-dots"/><p>O que achou dessa dica? <img src="https://s.w.org/images/core/emoji/13.1.0/72x72/1f601.png" alt="😁" class="wp-smiley" style="height: 1em; max-height: 1em;" /></p>
]]>
</content:encoded>
<wfw:commentRss>https://macmagazine.com.br/post/2021/12/16/como-abrir-todos-os-sites-de-uma-pasta-do-favoritos-do-safari-iphone-ipad-e-mac/feed/</wfw:commentRss>
<slash:comments>0</slash:comments>
<post-id xmlns="com-wordpress:feed-additions:1">841420</post-id>
<media:content xmlns:media="http://search.yahoo.com/mrss/" medium="image" type="image/jpeg" url="https://macmagazine.com.br/wp-content/uploads/2021/02/23-safari-1260x552.png" width="1200" height="526" />
</item>
<item>
    <title>Como saber se uma foto foi capturada no modo Noite [iPhone e iPad]</title>
    <link>https://macmagazine.com.br/post/2021/12/16/como-saber-se-uma-foto-foi-capturada-no-modo-noite-iphone-e-ipad/</link>
    <comments>https://macmagazine.com.br/post/2021/12/16/como-saber-se-uma-foto-foi-capturada-no-modo-noite-iphone-e-ipad/#respond</comments>
    <dc:creator>
        <![CDATA[Pedro Henrique Nunes]]>
    </dc:creator>
    <pubDate>Thu, 16 Dec 2021 09:50:00 +0000</pubDate>
    <category>
        <![CDATA[Apple]]>
    </category>
    <category>
        <![CDATA[Dicas]]>
    </category>
    <category>
        <![CDATA[Telefonia]]>
    </category>
    <category>
        <![CDATA[Tutoriais]]>
    </category>
    <category>
        <![CDATA[captura]]>
    </category>
    <category>
        <![CDATA[dica]]>
    </category>
    <category>
        <![CDATA[fotografia]]>
    </category>
    <category>
        <![CDATA[fotos]]>
    </category>
    <category>
        <![CDATA[iOS 15.2]]>
    </category>
    <category>
        <![CDATA[iPadOS 15.2]]>
    </category>
    <category>
        <![CDATA[iPhone 11]]>
    </category>
    <category>
        <![CDATA[iPhone 12]]>
    </category>
    <category>
        <![CDATA[iPhone 13]]>
    </category>
    <category>
        <![CDATA[Modo Noite]]>
    </category>
    <category>
        <![CDATA[Night Mode]]>
    </category>
    <category>
        <![CDATA[tutorial]]>
    </category>
    <guid isPermaLink="false">https://macmagazine.com.br/?p=841383</guid>
    <description>
        <![CDATA[Desde o lançamento dos iPhones 11, a Apple oferece um recurso que há anos estava presente nos smartphones&#8230;]]>
    </description>
    <content:encoded>
        <![CDATA[<img width="1200" height="900" src="https://macmagazine.com.br/wp-content/uploads/2020/10/Apple_iphone12pro-camera-demo-nightmode_10132020-1260x945.jpg" class="webfeedsFeaturedVisual wp-post-image" alt="Demo de foto com modo Noite no iPhone 12 Pro" style="display: block; margin: auto; margin-bottom: 5px;max-width: 100%;" link_thumbnail="" srcset="https://macmagazine.com.br/wp-content/uploads/2020/10/Apple_iphone12pro-camera-demo-nightmode_10132020-1260x945.jpg 1260w, https://macmagazine.com.br/wp-content/uploads/2020/10/Apple_iphone12pro-camera-demo-nightmode_10132020-600x450.jpg 600w, https://macmagazine.com.br/wp-content/uploads/2020/10/Apple_iphone12pro-camera-demo-nightmode_10132020-300x225.jpg 300w, https://macmagazine.com.br/wp-content/uploads/2020/10/Apple_iphone12pro-camera-demo-nightmode_10132020-1536x1152.jpg 1536w, https://macmagazine.com.br/wp-content/uploads/2020/10/Apple_iphone12pro-camera-demo-nightmode_10132020.jpg 1960w" sizes="(max-width: 1200px) 100vw, 1200px" /><p>Desde o lançamento dos iPhones 11, a Apple oferece um recurso que há anos estava presente nos smartphones da concorrência: a possibilidade de capturar fotos no <strong><a href="https://macmagazine.com.br/post/2021/02/04/o-que-e-e-como-funciona-o-modo-noite-nos-iphones/">modo Noite (<em>Night mode</em>)</a></strong>. </p><p>Isso acaba possibilitando que você capture imagens com pouca luz com um resultado bastante satisfatório, visualizando ainda mais detalhes da cena. </p><div class="cnvs-block-posts cnvs-block-posts-1639575594802 cnvs-block-posts-layout-horizontal-type-1" data-layout="horizontal-type-1" data-min-height=""><div class="cs-posts-area" data-posts-area=""><div class="cs-posts-area__outer"><div class="cs-posts-area__main cs-block-posts-layout-horizontal-type-1 cs-display-column cs-posts-area__image-width-half"><article class="post-762685 post type-post status-publish format-standard has-post-thumbnail category-apple category-dicas category-software category-telefonia category-tutoriais tag-camera tag-estabilizacao tag-foto tag-iphone-11 tag-iphone-11-pro tag-iphone-11-pro-max tag-iphone-12 tag-iphone-12-mini tag-iphone-12-pro tag-iphone-12-pro-max tag-modo-noite tag-modo-retrato tag-night-mode tag-noite tag-retrato tag-selfie tag-sensor tag-time-lapse tag-tripe cs-entry cs-video-wrap"><div class="cs-entry__outer"><div class="cs-entry__inner cs-entry__thumbnail cs-entry__overlay cs-overlay-ratio cs-ratio-landscape-16-9"><div class="cs-overlay-background cs-overlay-transparent"><img width="2560" height="1920" src="https://macmagazine.com.br/wp-content/uploads/2020/03/03-concurso-modo-noite-scaled.jpg" class="attachment-medium_large size-medium_large wp-post-image" alt="Concurso de fotografia da Apple - Modo Noite" srcset="https://macmagazine.com.br/wp-content/uploads/2020/03/03-concurso-modo-noite-scaled.jpg 2560w, https://macmagazine.com.br/wp-content/uploads/2020/03/03-concurso-modo-noite-600x450.jpg 600w, https://macmagazine.com.br/wp-content/uploads/2020/03/03-concurso-modo-noite-1260x945.jpg 1260w, https://macmagazine.com.br/wp-content/uploads/2020/03/03-concurso-modo-noite-300x225.jpg 300w, https://macmagazine.com.br/wp-content/uploads/2020/03/03-concurso-modo-noite-1536x1152.jpg 1536w, https://macmagazine.com.br/wp-content/uploads/2020/03/03-concurso-modo-noite-2048x1536.jpg 2048w" sizes="(max-width: 2560px) 100vw, 2560px" />
                                    </div><a class="cs-overlay-link" href="https://macmagazine.com.br/post/2021/02/04/o-que-e-e-como-funciona-o-modo-noite-nos-iphones/"></a></div><div class="cs-entry__inner cs-entry__content"><h2 class="cs-entry__title "><a href="https://macmagazine.com.br/post/2021/02/04/o-que-e-e-como-funciona-o-modo-noite-nos-iphones/">O que é e como funciona o modo Noite nos iPhones?</a></h2><div class="cs-entry__post-meta" ><div class="cs-meta-author"><a class="cs-meta-author-inner url fn n" href="https://macmagazine.com.br/post/author/pedro/" title="View all posts by Pedro Henrique Nunes"><span class="cs-by">por</span><span class="cs-author">Pedro Henrique Nunes</span></a></div><div class="cs-meta-date">04/02/2021 • 08:15</div></div>        </div>
    </div></article>
                </div>
            </div>

                    </div>
    </div><p>Pois, a partir do <a href="https://macmagazine.com.br/post/2021/12/13/apple-lanca-ios-15-2-e-ipados-15-2-para-todos-os-usuarios/">iOS/iPadOS 15.2</a>, a Apple passou a indicar quando uma foto foi tirada usando essa configuração, o que pode ser bastante útil para muita gente.</p><p>Veja só como é fácil conferir essa informação: abra o Fotos (<em>Photos</em>) e escolha a imagem que deseja fazer a verificação. Em seguida, deslize o dedo de baixo para cima a partir dela para visualizar as informações da captura (ou toque no &#8220;i&#8221;).</p><div class="wp-block-image"><figure class="aligncenter size-large is-resized"><a href="https://macmagazine.com.br/wp-content/uploads/2021/12/15-foto-modo-noite-icone.png"><img src="https://macmagazine.com.br/wp-content/uploads/2021/12/15-foto-modo-noite-icone-638x1260.png" alt="" class="wp-image-841392" width="319" height="630" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/15-foto-modo-noite-icone-638x1260.png 638w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-foto-modo-noite-icone-304x600.png 304w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-foto-modo-noite-icone-152x300.png 152w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-foto-modo-noite-icone-778x1536.png 778w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-foto-modo-noite-icone-1037x2048.png 1037w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-foto-modo-noite-icone-380x750.png 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-foto-modo-noite-icone-800x1579.png 800w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-foto-modo-noite-icone-1160x2290.png 1160w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-foto-modo-noite-icone.png 1325w" sizes="(max-width: 319px) 100vw, 319px" /></a></figure></div><p>Caso a foto tenha sido tirada usando o modo Noite, você verá um ícone representado por uma lua ao lado direito, junto ao tempo de exposição da captura.</p><p>Legal, né?! <img src="https://s.w.org/images/core/emoji/13.1.0/72x72/1f30c.png" alt="🌌" class="wp-smiley" style="height: 1em; max-height: 1em;" /></p><p><span class="credito">via <a href="https://9to5mac.com/2021/12/14/ios-15-2-changes-features-whats-new-video/">9to5Mac</a></span></p>
]]>
</content:encoded>
<wfw:commentRss>https://macmagazine.com.br/post/2021/12/16/como-saber-se-uma-foto-foi-capturada-no-modo-noite-iphone-e-ipad/feed/</wfw:commentRss>
<slash:comments>0</slash:comments>
<post-id xmlns="com-wordpress:feed-additions:1">841383</post-id>
<media:content xmlns:media="http://search.yahoo.com/mrss/" medium="image" type="image/jpeg" url="https://macmagazine.com.br/wp-content/uploads/2020/10/Apple_iphone12pro-camera-demo-nightmode_10132020-1260x945.jpg" width="1200" height="900" />
</item>
<item>
    <title>Apple TV+ lança curta de Natal de &#8220;Ted Lasso&#8221; no YouTube</title>
    <link>https://macmagazine.com.br/post/2021/12/15/apple-tv-lanca-curta-de-natal-de-ted-lasso-no-youtube/</link>
    <comments>https://macmagazine.com.br/post/2021/12/15/apple-tv-lanca-curta-de-natal-de-ted-lasso-no-youtube/#respond</comments>
    <dc:creator>
        <![CDATA[Douglas Nascimento]]>
    </dc:creator>
    <pubDate>Thu, 16 Dec 2021 00:07:55 +0000</pubDate>
    <category>
        <![CDATA[Apple]]>
    </category>
    <category>
        <![CDATA[Destaques]]>
    </category>
    <category>
        <![CDATA[Vídeos]]>
    </category>
    <category>
        <![CDATA[Apple TV]]>
    </category>
    <category>
        <![CDATA[Apple TV+]]>
    </category>
    <category>
        <![CDATA[curta-metragem]]>
    </category>
    <category>
        <![CDATA[Jason Sudeikis]]>
    </category>
    <category>
        <![CDATA[Natal]]>
    </category>
    <category>
        <![CDATA[seriado]]>
    </category>
    <category>
        <![CDATA[Série]]>
    </category>
    <category>
        <![CDATA[Ted Lasso]]>
    </category>
    <category>
        <![CDATA[Ted Lasso — The Missing Christmas Mustache]]>
    </category>
    <category>
        <![CDATA[TV]]>
    </category>
    <category>
        <![CDATA[vídeo]]>
    </category>
    <guid isPermaLink="false">https://macmagazine.com.br/?p=841609</guid>
    <description>
        <![CDATA[Tendo a série &#8220;Ted Lasso&#8221; como um dos carros-chefe do seu catálogo, o Apple TV+ deu um presente&#8230;]]>
    </description>
    <content:encoded>
        <![CDATA[<img width="1200" height="675" src="https://macmagazine.com.br/wp-content/uploads/2021/12/15-ted-lasso-1260x709.jpg" class="webfeedsFeaturedVisual wp-post-image" alt="&quot;Ted Lasso — The Missing Christmas Mustache&quot;" style="display: block; margin: auto; margin-bottom: 5px;max-width: 100%;" link_thumbnail="" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/15-ted-lasso-1260x709.jpg 1260w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-ted-lasso-600x338.jpg 600w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-ted-lasso-300x169.jpg 300w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-ted-lasso-380x214.jpg 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-ted-lasso-800x450.jpg 800w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-ted-lasso-1160x653.jpg 1160w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-ted-lasso.jpg 1280w" sizes="(max-width: 1200px) 100vw, 1200px" /><p>Tendo a série <strong><a href="https://tv.apple.com/br/show/ted-lasso/umc.cmc.vtoh0mn0xn7t3c643xqonfzy?at=10lt3B">&#8220;Ted Lasso&#8221;</a></strong> como um dos carros-chefe do seu catálogo, o <strong>Apple TV+</strong> deu um presente de Natal para lá de especial para quem curte a produção estrelada por<strong>Jason Sudeikis</strong>.</p><p>Trata-se de um curta-metragem animado lançado no canal oficial da plataforma no YouTube, contando com as vozes dos personagens da série premiada. </p><p>No curta, intitulado <strong><a href="https://www.apple.com/tv-pr/news/2021/12/apples-emmy-award-winning-hit-comedy-ted-lasso-adds-joy-to-the-season-with-animated-holiday-short/"><em>&#8220;Ted Lasso — The Missing Christmas Mustache&#8221;</em></a></strong> (algo como &#8220;Ted Lasso — O Bigode de Natal Desaparecido&#8221;), o treinador do AFC Richmond perde o seu bigode um pouco antes de fazer um <a href="https://apps.apple.com/br/app/facetime/id1110145091">FaceTime</a> de Natal com seu filho — o que deixa o protagonista num tremendo desespero.</p><p>Com isso, o personagem de Sudeikis contará com a ajuda de seus amigos para procurar o item perdido, o que o levará a descobrir o real significado do Natal.</p><figure class="wp-block-embed aligncenter is-type-video is-provider-youtube wp-block-embed-youtube wp-embed-aspect-16-9 wp-has-aspect-ratio"><div class="wp-block-embed__wrapper"><iframe loading="lazy" title="Ted Lasso — The Missing Christmas Mustache | Apple TV+" width="1200" height="675" src="https://www.youtube.com/embed/UW_qXIHtmTk?feature=oembed" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div></figure><p>&#8220;Ted Lasso&#8221;, vale recordar, já teve duas temporadas lançadas e é um sucesso inquestionável, aclamada tanto pelo público quanto pela crítica (com <a href="https://macmagazine.com.br/post/2021/09/15/ted-lasso-leva-3-premios-dos-criticos-dos-eua-incluindo-serie-do-ano/">vários prêmios e indicações</a>). A terceira temporada<a href="https://macmagazine.com.br/post/2020/10/28/apple-confirma-3a-temporada-de-ted-lasso-e-exalta-sucesso-da-serie/">já foi confirmada</a>, é claro.</p><p>O Apple TV+ está disponível no app Apple TV em mais de 100 países e regiões, seja em iPhones, iPads, Apple TVs, Macs, smart TVs ou online — além também estar em aparelhos como Roku, Amazon Fire TV, Chromecast com Google TV, consoles PlayStation e Xbox. O serviço <a href="https://apple.co/2Z6v2i4">custa <strong>R$9,90 por mês</strong></a>, com um período de teste gratuito de sete dias. Por tempo limitado, quem comprar e ativar um novo iPhone, iPad, Apple TV, Mac ou iPod touch ganha três meses de Apple TV+. Ele também faz parte do pacote de assinaturas da empresa, o <a href="https://macmagazine.com.br/post/2020/10/30/apple-one-esta-agora-disponivel-veja-como-assinar/">Apple One</a>.</p><hr /><div class="appbox"><div class="appbox-icon"><a href="https://apps.apple.com/br/app/apple-tv/id1174078549" target="_blank"><img class="appbox-iconiOS" alt="&Iacute;cone do app Apple TV" src="https://is5-ssl.mzstatic.com/image/thumb/Purple116/v4/42/6e/37/426e37bf-dcbd-79a1-2927-cd7889239dad/AppIcon-0-0-1x_U007emarketing-0-0-0-7-0-0-sRGB-0-0-0-GLES2_U002c0-512MB-85-220-0-0.png/256x256bb.png" /></a></div><div class="appbox-details"><span class="appbox-name"><a href="https://apps.apple.com/br/app/apple-tv/id1174078549" target="_blank">Apple TV</a></span><span class="appbox-de">de <strong><a href="https://www.apple.com/br/apple-tv-app/" target="_blank" class="no_icon" rel="nofollow">Apple</a></strong></span><div class="appbox-devices"><img src="https://macmagazine.com.br/wp-content/uploads/2015/11/devices_ipad.png" alt="Compat&iacute;vel com iPads" title="Compat&iacute;vel com iPads" class="appbox-devicesiPad" /><img src="https://macmagazine.com.br/wp-content/uploads/2015/11/devices_iphone.png" alt="Compat&iacute;vel com iPhones" title="Compat&iacute;vel com iPhones" class="appbox-devicesiPhone" /></div><div class="appbox-info">Vers&atilde;o <strong>1.7</strong> (888.8 KB)<br />
                    Requer o <strong>iOS 10.2</strong> ou superior</div></div><div class="appbox-badge"><span class="appbox-price">Gr&aacute;tis</span><span><a href="https://apps.apple.com/br/app/apple-tv/id1174078549" target="_blank"><img alt="Badge - Baixar na App Store" src="https://macmagazine.com.br/wp-content/uploads/2017/11/22-badge_appstore.png" class="badgeInvert" /></a></span><span class="appbox-QRcode"><a href="javascript:void(0);" title="C&oacute;digo QR - Apple TV" onclick="javascript:abrirQR('https://chart.googleapis.com/chart?chs=400x400&cht=qr&chl=https%3A%2F%2Fapps.apple.com%2Fbr%2Fapp%2Fapple-tv%2Fid1174078549&chld=L|0');return false;"><img alt="C&oacute;digo QR" src="https://macmagazine.com.br/wp-content/themes/newsblock-child/images/qr.png" /></a><a href="javascript:void(0);" title="C&oacute;digo QR - Apple TV" onclick="javascript:abrirQR('https://chart.googleapis.com/chart?chs=400x400&cht=qr&chl=https%3A%2F%2Fapps.apple.com%2Fbr%2Fapp%2Fapple-tv%2Fid1174078549&chld=L|0');return false;">C&oacute;digo QR</a></span></div>
                </div>
]]>
</content:encoded>
<wfw:commentRss>https://macmagazine.com.br/post/2021/12/15/apple-tv-lanca-curta-de-natal-de-ted-lasso-no-youtube/feed/</wfw:commentRss>
<slash:comments>0</slash:comments>
<post-id xmlns="com-wordpress:feed-additions:1">841609</post-id>
<media:content xmlns:media="http://search.yahoo.com/mrss/" medium="image" type="image/jpeg" url="https://macmagazine.com.br/wp-content/uploads/2021/12/15-ted-lasso-1260x709.jpg" width="1200" height="675" />
</item>
<item>
    <title>Criador de &#8220;The Shrink Next Door&#8221; está processando a Bloomberg</title>
    <link>https://macmagazine.com.br/post/2021/12/15/criador-de-the-shrink-next-door-esta-processando-a-bloomberg/</link>
    <comments>https://macmagazine.com.br/post/2021/12/15/criador-de-the-shrink-next-door-esta-processando-a-bloomberg/#respond</comments>
    <dc:creator>
        <![CDATA[Diogo Ammon]]>
    </dc:creator>
    <pubDate>Wed, 15 Dec 2021 23:38:50 +0000</pubDate>
    <category>
        <![CDATA[Apple]]>
    </category>
    <category>
        <![CDATA[Dinheiro]]>
    </category>
    <category>
        <![CDATA[Projetos]]>
    </category>
    <category>
        <![CDATA[adaptação]]>
    </category>
    <category>
        <![CDATA[Apple TV+]]>
    </category>
    <category>
        <![CDATA[Bloomberg]]>
    </category>
    <category>
        <![CDATA[Bloomberg Media]]>
    </category>
    <category>
        <![CDATA[contrato]]>
    </category>
    <category>
        <![CDATA[criador]]>
    </category>
    <category>
        <![CDATA[direitos]]>
    </category>
    <category>
        <![CDATA[história]]>
    </category>
    <category>
        <![CDATA[Joe Nocera]]>
    </category>
    <category>
        <![CDATA[Jornalista]]>
    </category>
    <category>
        <![CDATA[MRC Studios]]>
    </category>
    <category>
        <![CDATA[o psiquiatra ao lado]]>
    </category>
    <category>
        <![CDATA[Podcast]]>
    </category>
    <category>
        <![CDATA[receita]]>
    </category>
    <category>
        <![CDATA[the shrink next door]]>
    </category>
    <category>
        <![CDATA[Washington Post]]>
    </category>
    <category>
        <![CDATA[Wondery]]>
    </category>
    <guid isPermaLink="false">https://macmagazine.com.br/?p=841552</guid>
    <description>
        <![CDATA[A minissérie &#8220;The Shrink Next Door&#8221; (&#8220;O Psiquiatra ao Lado&#8221;) chegou às telas do Apple TV+ em novembro&#8230;]]>
    </description>
    <content:encoded>
        <![CDATA[<img width="1200" height="675" src="https://macmagazine.com.br/wp-content/uploads/2021/10/12-The_Shrink_Next_Door-1260x709.jpg" class="webfeedsFeaturedVisual wp-post-image" alt="The Shrink Next Door" style="display: block; margin: auto; margin-bottom: 5px;max-width: 100%;" link_thumbnail="" srcset="https://macmagazine.com.br/wp-content/uploads/2021/10/12-The_Shrink_Next_Door-1260x709.jpg 1260w, https://macmagazine.com.br/wp-content/uploads/2021/10/12-The_Shrink_Next_Door-600x338.jpg 600w, https://macmagazine.com.br/wp-content/uploads/2021/10/12-The_Shrink_Next_Door-300x169.jpg 300w, https://macmagazine.com.br/wp-content/uploads/2021/10/12-The_Shrink_Next_Door-1536x864.jpg 1536w, https://macmagazine.com.br/wp-content/uploads/2021/10/12-The_Shrink_Next_Door-2048x1152.jpg 2048w, https://macmagazine.com.br/wp-content/uploads/2021/10/12-The_Shrink_Next_Door-380x214.jpg 380w, https://macmagazine.com.br/wp-content/uploads/2021/10/12-The_Shrink_Next_Door-800x450.jpg 800w, https://macmagazine.com.br/wp-content/uploads/2021/10/12-The_Shrink_Next_Door-1160x653.jpg 1160w, https://macmagazine.com.br/wp-content/uploads/2021/10/12-The_Shrink_Next_Door.jpg 3840w" sizes="(max-width: 1200px) 100vw, 1200px" /><p>A minissérie <strong><a href="https://tv.apple.com/br/show/o-psiquiatra-ao-lado/umc.cmc.jov1gljmqnux0i15rbqsoyfk?at=10lt3B"><em>&#8220;The Shrink Next Door&#8221;</em></a> (&#8220;O Psiquiatra ao Lado&#8221;)</strong> chegou às telas do <strong>Apple TV+</strong><a href="https://macmagazine.com.br/post/2021/11/12/estreias-do-dia-no-apple-tv-o-psiquiatra-ao-lado-e-snoopy-no-espaco/">em novembro passado</a>, e gira em torno da relação complicada entre um psiquiatra (interpretado por<strong>Paul Rudd</strong>) e um de seus pacientes (vivido por<strong>Will Ferrell</strong>).</p><p>A Apple <a href="https://macmagazine.com.br/post/2020/04/25/apple-tv-tera-minisserie-de-comedia-com-will-ferrell-e-paul-rudd-experiencia-visual-do-novo-album-do-pearl-jam-esta-disponivel/">adquiriu os direito da comédia</a> em abril de 2020. Na época, ela fazia sucesso como um podcast da<strong>Wondery</strong>, contando a história da série — a qual, vale notar, é baseada em fatos reais que ocorreram com conhecidos do criador do podcast,<strong>Joe Nocera</strong> — que trabalhava para a<strong><em>Bloomberg News</em></strong>.</p><p>Agora, segundo <a href="https://www.washingtonpost.com/media/2021/12/14/shrink-next-door-joe-nocera-sues-bloomberg/">uma reportagem do <em>Washington Post</em></a>, Nocera está processando seu ex-empregador, a Bloomberg Media, por quebra de contrato — argumentando que a empresa de mídia deve a ele lucros relativos à adaptação da Apple.</p><p>Nocera se juntou à Wondery quando ainda era colunista da <em>Bloomberg</em> para transformar uma de suas histórias não publicadas em um podcast. Na época,<em>Bloomberg</em> e Wondery tinham uma parceria na qual colaborariam em podcasts — um dos resultados foi a história de Marty Markowitz (Ferrell) e seu terapeuta Isaac &#8220;Ike&#8221; Herschkopf (Rudd).</p><p>Com o sucesso, os direitos do podcast foram adquiridos pela <strong>MRC Studios</strong>, com a Wondery e a<em>Bloomberg</em> dividindo as receitas geradas por meio de um acordo com a MRC. O processo declara que<em>Bloomberg</em> e Nocera também haviam firmado um acordo entre si, no qual ambos dividiram igualmente as receitas que a empresa obtivesse da exploração do podcast por terceiros não afiliados à<em>Bloomberg</em> — um deles, claro, a Apple.</p><p>Nocera esperava receber metade do valor da opção inicial para a série (US$125 mil), mas a <em>Bloomberg</em> disse que ele não teria direito a nenhuma receita de publicidade da série, citando a posição da empresa de que os jornalistas não tinham direito aos lucros com propaganda. Nocera, por sua vez, argumenta que isso viola a parte do contrato a qual diz que eles dividiriam todas as receitas geradas &#8220;por terceiros não afiliados à<em>Bloomberg</em>&#8220;.</p><p>Por outro lado, a <em>Bloomberg</em> reconhece que a MRC devia a Nocera cerca de US$322 mil, mas que a maior parte desse dinheiro já foi paga, faltando cerca de US$35 mil. Nocera, entretanto, argumenta que o valor a ser recebido por ele deveria ser muito maior.<a href="https://www.thewrap.com/shrink-next-door-lawsuit-bloomberg-profits-apple-tv-plus/">Ao <em>The Wrap</em></a>, um porta-voz da <em>Bloomberg News</em> disse que a empresa continuaria a honrar todas as suas obrigações contratuais com o jornalista.</p><p>O <a href="https://www.washingtonpost.com/media/2021/12/14/shrink-next-door-joe-nocera-sues-bloomberg/">artigo do <em>Washington Post</em></a> ainda detalha outras polêmicas envolvendo Nocera, uma das quais levou à sua demissão da <em>Bloomberg</em>. De qualquer forma, ainda não há como saber quem está certo nessa história.</p>
]]>
</content:encoded>
<wfw:commentRss>https://macmagazine.com.br/post/2021/12/15/criador-de-the-shrink-next-door-esta-processando-a-bloomberg/feed/</wfw:commentRss>
<slash:comments>0</slash:comments>
<post-id xmlns="com-wordpress:feed-additions:1">841552</post-id>
<media:content xmlns:media="http://search.yahoo.com/mrss/" medium="image" type="image/jpeg" url="https://macmagazine.com.br/wp-content/uploads/2021/10/12-The_Shrink_Next_Door-1260x709.jpg" width="1200" height="675" />
</item>
<item>
    <title>Apple adia retorno presencial por tempo indeterminado (sim, de novo)</title>
    <link>https://macmagazine.com.br/post/2021/12/15/apple-adia-retorno-presencial-por-tempo-indeterminado-sim-de-novo/</link>
    <comments>https://macmagazine.com.br/post/2021/12/15/apple-adia-retorno-presencial-por-tempo-indeterminado-sim-de-novo/#respond</comments>
    <dc:creator>
        <![CDATA[Douglas Nascimento]]>
    </dc:creator>
    <pubDate>Wed, 15 Dec 2021 23:01:20 +0000</pubDate>
    <category>
        <![CDATA[Apple]]>
    </category>
    <category>
        <![CDATA[Destaques]]>
    </category>
    <category>
        <![CDATA[Dinheiro]]>
    </category>
    <category>
        <![CDATA[Apple Inc]]>
    </category>
    <category>
        <![CDATA[Apple Park]]>
    </category>
    <category>
        <![CDATA[Corporação]]>
    </category>
    <category>
        <![CDATA[COVID-19]]>
    </category>
    <category>
        <![CDATA[empregados]]>
    </category>
    <category>
        <![CDATA[escritórios]]>
    </category>
    <category>
        <![CDATA[funcionários]]>
    </category>
    <category>
        <![CDATA[Mark Gurman]]>
    </category>
    <category>
        <![CDATA[Omicron]]>
    </category>
    <category>
        <![CDATA[pandemia]]>
    </category>
    <category>
        <![CDATA[retorno dos funcionários]]>
    </category>
    <category>
        <![CDATA[Saúde]]>
    </category>
    <category>
        <![CDATA[Tim Cook]]>
    </category>
    <guid isPermaLink="false">https://macmagazine.com.br/?p=841570</guid>
    <description>
        <![CDATA[Com a disseminação de novas variantes da COVID-19 e o surgimento de surtos do vírus entre funcionários, a&#8230;]]>
    </description>
    <content:encoded>
        <![CDATA[<img width="1200" height="800" src="https://macmagazine.com.br/wp-content/uploads/2021/12/09-Apple-Park-Wallpaper-12-1260x840.jpg" class="webfeedsFeaturedVisual wp-post-image" alt="Apple Park na Wallpaper*" style="display: block; margin: auto; margin-bottom: 5px;max-width: 100%;" link_thumbnail="" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/09-Apple-Park-Wallpaper-12-1260x840.jpg 1260w, https://macmagazine.com.br/wp-content/uploads/2021/12/09-Apple-Park-Wallpaper-12-600x400.jpg 600w, https://macmagazine.com.br/wp-content/uploads/2021/12/09-Apple-Park-Wallpaper-12-300x200.jpg 300w, https://macmagazine.com.br/wp-content/uploads/2021/12/09-Apple-Park-Wallpaper-12-380x253.jpg 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/09-Apple-Park-Wallpaper-12-800x533.jpg 800w, https://macmagazine.com.br/wp-content/uploads/2021/12/09-Apple-Park-Wallpaper-12-1160x773.jpg 1160w, https://macmagazine.com.br/wp-content/uploads/2021/12/09-Apple-Park-Wallpaper-12.jpg 1460w" sizes="(max-width: 1200px) 100vw, 1200px" /><p>Com a disseminação de novas variantes da COVID-19 e o surgimento de surtos do vírus entre funcionários, a Apple vem tomando decisões nada animadoras. Após <a href="https://macmagazine.com.br/post/2021/12/15/apple-fecha-3-lojas-de-uma-vez-apos-novos-surtos-de-covid-19/">fechar temporariamente três lojas físicas</a> de uma só vez, a empresa acaba de suspender o retorno presencial dos funcionários corporativos.</p><p>A informação foi dada pelo jornalista <strong>Mark Gurman</strong>,<a href="https://www.bloomberg.com/news/articles/2021-12-15/apple-delays-return-to-office-until-date-yet-to-be-determined">na <em>Bloomberg</em></a>. Segundo ele, o retorno das atividades corporativas em escritórios físicos, que estava programado para 1º de fevereiro, foi adiado para uma nova data &#8220;ainda não determinada&#8221; pela Apple, decisão que foi efetivada em memorando enviado hoje por <strong>Tim Cook</strong> aos funcionários.</p><figure class="wp-block-embed aligncenter is-type-rich is-provider-twitter wp-block-embed-twitter"><div class="wp-block-embed__wrapper"><blockquote class="twitter-tweet" data-width="550" data-dnt="true"><p lang="en" dir="ltr">Breaking on <a href="https://twitter.com/TheTerminal?ref_src=twsrc%5Etfw">@TheTerminal</a>: Apple delays corporate office return to “date yet to be determined.” Was supposed to be February 1.</p>&mdash; Mark Gurman (@markgurman) <a href="https://twitter.com/markgurman/status/1471237100255252484?ref_src=twsrc%5Etfw">December 15, 2021</a></blockquote><script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script></div></figure><p>O retorno das atividades presenciais é visto com expectativa como um dos últimos passos para a normalização total dos trabalhos da empresa. Agora, o mercado terá que esperar mais um pouco até que isso se concretize, principalmente após acontecimentos recentes não tão animadores.</p><p>O próprio Gurman, <a href="https://www.bloomberg.com/news/articles/2021-12-15/apple-temporarily-shuts-three-retail-stores-after-covid-19-surge">na matéria</a> que escreveu mais cedo na<em>Bloomberg</em> noticiando o fechamento das lojas da Apple nos EUA e no Canadá, aventou a possibilidade de o aumento dos casos de COVID-19 atrapalhar os planos da Maçã para o retorno dos funcionários corporativos.</p><p>Na publicação, ficou claro que os casos envolvendo o vírus vêm aumentando nos Estados Unidos, em boa parte por causa da variante Ômicron. Não é leviano concluir que a decisão da Apple sobre o retorno dos funcionários tem relação direta com esse aumento.</p><p>Fato é que a suspensão deverá animar os trabalhadores da empresa, que temiam o retorno aos escritórios físicos. <a href="https://macmagazine.com.br/post/2021/06/05/empregados-da-apple-reclamam-de-retorno-ao-trabalho-presencial/">Como publicamos em junho</a>, um grupo de ao menos 80 empregados não ficou nada satisfeito com a notícia de que teriam que retornar ao ambiente corporativo (na época, a expectativa ainda era de que isso acontecesse em setembro).</p>
]]>
</content:encoded>
<wfw:commentRss>https://macmagazine.com.br/post/2021/12/15/apple-adia-retorno-presencial-por-tempo-indeterminado-sim-de-novo/feed/</wfw:commentRss>
<slash:comments>0</slash:comments>
<post-id xmlns="com-wordpress:feed-additions:1">841570</post-id>
<media:content xmlns:media="http://search.yahoo.com/mrss/" medium="image" type="image/jpeg" url="https://macmagazine.com.br/wp-content/uploads/2021/12/09-Apple-Park-Wallpaper-12-1260x840.jpg" width="1200" height="800" />
</item>
<item>
    <title>Promoções na App Store: Rikudo Puzzles, Starlight, Total Video Player e mais!</title>
    <link>https://macmagazine.com.br/post/2021/12/15/promocoes-na-app-store-rikudo-puzzles-starlight-total-video-player-e-mais/</link>
    <comments>https://macmagazine.com.br/post/2021/12/15/promocoes-na-app-store-rikudo-puzzles-starlight-total-video-player-e-mais/#respond</comments>
    <dc:creator>
        <![CDATA[Marcelo Melo]]>
    </dc:creator>
    <pubDate>Wed, 15 Dec 2021 22:54:24 +0000</pubDate>
    <category>
        <![CDATA[Dicas]]>
    </category>
    <category>
        <![CDATA[Dinheiro]]>
    </category>
    <category>
        <![CDATA[Gadgets]]>
    </category>
    <category>
        <![CDATA[Jogos]]>
    </category>
    <category>
        <![CDATA[Mac]]>
    </category>
    <category>
        <![CDATA[Software]]>
    </category>
    <category>
        <![CDATA[aplicativos]]>
    </category>
    <category>
        <![CDATA[App Store]]>
    </category>
    <category>
        <![CDATA[apps]]>
    </category>
    <category>
        <![CDATA[ETA - Arrive on time]]>
    </category>
    <category>
        <![CDATA[Mac App Store]]>
    </category>
    <category>
        <![CDATA[Number Mazes: Rikudo Puzzles]]>
    </category>
    <category>
        <![CDATA[promoção]]>
    </category>
    <category>
        <![CDATA[Starlight: Mapa do Céu]]>
    </category>
    <category>
        <![CDATA[The Christmas List]]>
    </category>
    <category>
        <![CDATA[Total Video Player]]>
    </category>
    <guid isPermaLink="false">https://macmagazine.com.br/?p=841579</guid>
    <description>
        <![CDATA[Para esta quarta-feira, aproveite a nossa seleção de promoções na App Store! Rikudo é um jogo de lógica,&#8230;]]>
    </description>
    <content:encoded>
        <![CDATA[<img width="984" height="502" src="https://macmagazine.com.br/wp-content/uploads/2021/12/15-Rikudo.png" class="webfeedsFeaturedVisual wp-post-image" alt="Rikudo" style="display: block; margin: auto; margin-bottom: 5px;max-width: 100%;" link_thumbnail="" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/15-Rikudo.png 984w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-Rikudo-600x306.png 600w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-Rikudo-300x153.png 300w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-Rikudo-380x194.png 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-Rikudo-800x408.png 800w" sizes="(max-width: 984px) 100vw, 984px" /><p>Para esta quarta-feira, aproveite a nossa seleção de <strong>promoções na App Store</strong>!</p><p class="has-text-align-left wp-embed-aspect-16-9 wp-has-aspect-ratio"><strong>Rikudo</strong> é um jogo de lógica, desenvolvido por uma empresa homônima e nossa escolha para destaque do dia.</p><p>Seu objetivo é encontrar o caminho de número consecutivos em um favo de mel (hexagonal de células). São mais de 900 fases, algumas com dicas e um modo do mal para quem curte um desafio ainda maior.</p><hr /><div class="appbox"><div class="appbox-icon"><a href="https://apps.apple.com/br/app/number-mazes-rikudo-puzzles/id1073513516" target="_blank"><img class="appbox-iconiOS" alt="&Iacute;cone do app Number Mazes: Rikudo Puzzles" src="https://is5-ssl.mzstatic.com/image/thumb/Purple124/v4/37/a9/ed/37a9ed7b-32f6-81a5-a637-7e14f23058b9/AppIcon-0-1x_U007emarketing-0-85-220-7.png/256x256bb.png" /></a></div><div class="appbox-details"><span class="appbox-name"><a href="https://apps.apple.com/br/app/number-mazes-rikudo-puzzles/id1073513516" target="_blank">Number Mazes: Rikudo Puzzles</a></span><span class="appbox-de">de <strong><a href="" target="_blank" class="no_icon" rel="nofollow">Rikudo</a></strong></span><div class="appbox-devices"><img src="https://macmagazine.com.br/wp-content/uploads/2015/11/devices_ipad.png" alt="Compat&iacute;vel com iPads" title="Compat&iacute;vel com iPads" class="appbox-devicesiPad" /><img src="https://macmagazine.com.br/wp-content/uploads/2015/11/devices_iphone.png" alt="Compat&iacute;vel com iPhones" title="Compat&iacute;vel com iPhones" class="appbox-devicesiPhone" /></div><div class="appbox-info">Vers&atilde;o <strong>1.1</strong> (92.1 MB)<br />
                    Requer o <strong>iOS 8.0</strong> ou superior</div></div><div class="appbox-badge"><span class="appbox-price">Gr&aacute;tis <b class="appbox-oldprice">R$ 16.90</b></span><span><a href="https://apps.apple.com/br/app/number-mazes-rikudo-puzzles/id1073513516" target="_blank"><img alt="Badge - Baixar na App Store" src="https://macmagazine.com.br/wp-content/uploads/2017/11/22-badge_appstore.png" class="badgeInvert" /></a></span><span class="appbox-QRcode"><a href="javascript:void(0);" title="C&oacute;digo QR - Number Mazes: Rikudo Puzzles" onclick="javascript:abrirQR('https://chart.googleapis.com/chart?chs=400x400&cht=qr&chl=https%3A%2F%2Fapps.apple.com%2Fbr%2Fapp%2Fnumber-mazes-rikudo-puzzles%2Fid1073513516&chld=L|0');return false;"><img alt="C&oacute;digo QR" src="https://macmagazine.com.br/wp-content/themes/newsblock-child/images/qr.png" /></a><a href="javascript:void(0);" title="C&oacute;digo QR - Number Mazes: Rikudo Puzzles" onclick="javascript:abrirQR('https://chart.googleapis.com/chart?chs=400x400&cht=qr&chl=https%3A%2F%2Fapps.apple.com%2Fbr%2Fapp%2Fnumber-mazes-rikudo-puzzles%2Fid1073513516&chld=L|0');return false;">C&oacute;digo QR</a></span></div>
                </div><div class="appbox-screenshots"><img src="https://is1-ssl.mzstatic.com/image/thumb/Purple128/v4/b4/af/81/b4af816c-69ce-5bc7-45f5-ce39af9a0d16/pr_source.png/1242x2208bb.jpg" class="appbox-screenshotsIMG" alt="Screenshot do app Number Mazes: Rikudo Puzzles" style="width: 320px;" /><img src="https://is5-ssl.mzstatic.com/image/thumb/Purple118/v4/0d/e8/8f/0de88ff8-26cd-13c3-f0f5-dab6f4f7d92d/pr_source.png/1242x2208bb.jpg" class="appbox-screenshotsIMG" alt="Screenshot do app Number Mazes: Rikudo Puzzles" style="width: 320px;" /><img src="https://is4-ssl.mzstatic.com/image/thumb/Purple128/v4/31/31/8a/31318ade-1c08-bda1-e4d9-037c6f39aebd/pr_source.png/1242x2208bb.jpg" class="appbox-screenshotsIMG" alt="Screenshot do app Number Mazes: Rikudo Puzzles" style="width: 320px;" /><img src="https://is2-ssl.mzstatic.com/image/thumb/Purple118/v4/a0/ef/9e/a0ef9e32-28bb-fb7d-4536-a21b38023f11/pr_source.png/1242x2208bb.jpg" class="appbox-screenshotsIMG" alt="Screenshot do app Number Mazes: Rikudo Puzzles" style="width: 320px;" /><img src="https://is2-ssl.mzstatic.com/image/thumb/Purple128/v4/08/c6/72/08c67221-2452-37f2-f2b8-35a3ddf47ff8/pr_source.png/1242x2208bb.jpg" class="appbox-screenshotsIMG" alt="Screenshot do app Number Mazes: Rikudo Puzzles" style="width: 320px;" /><img src="https://is2-ssl.mzstatic.com/image/thumb/Purple118/v4/54/f2/c3/54f2c345-c3ab-7ddb-6507-950ed8410ac7/pr_source.png/1242x2208bb.jpg" class="appbox-screenshotsIMG" alt="Screenshot do app Number Mazes: Rikudo Puzzles" style="width: 320px;" /><img src="https://is5-ssl.mzstatic.com/image/thumb/Purple128/v4/38/bf/a0/38bfa0bf-8fca-cc6b-78f7-70aad89245ea/pr_source.png/1242x2208bb.jpg" class="appbox-screenshotsIMG" alt="Screenshot do app Number Mazes: Rikudo Puzzles" style="width: 320px;" /></div><div class="appbox-rating"><div class="appbox-ratingCell" style="border-right-width: 4px;"><strong>N/D</strong><br />Nota na App Store</div><div class="appbox-ratingCell" style="border-left-width: 4px;"><span class="estrela estrela-inteira"></span><span class="estrela estrela-inteira"></span><span class="estrela estrela-inteira"></span><span class="estrela estrela-inteira"></span><span class="estrela estrela-vazia"></span><br />Minha nota</div>
                    </div><blockquote class="wp-block-quote"><p>As regras são simples. Coloque um número em cada hexágono de forma que dois números consecutivos sejam vizinhos. No final, o encadeamento dos números consecutivos devem formar um caminho que passa por todos os hexágonos e por todos os diamantes que conectam alguns deles.</p></blockquote><p>Curtiu? Aproveite a oferta e boa diversão! <img src="https://s.w.org/images/core/emoji/13.1.0/72x72/1f600.png" alt="😀" class="wp-smiley" style="height: 1em; max-height: 1em;" /></p><hr class="wp-block-separator is-style-dots is-cnvs-separator-id-1618912657762"/><p>Abaixo outros aplicativos que, juntos, somam <strong>quase R$87 em descontos</strong>:</p><h2>Apps para iOS/iPadOS/watchOS</h2><hr /><div class="appbox"><div class="appbox-icon"><a href="https://apps.apple.com/br/app/starlight-mapa-do-c%C3%A9u/id762002305" target="_blank"><img class="appbox-iconiOS" alt="&Iacute;cone do app Starlight: Mapa do C&eacute;u" src="https://is4-ssl.mzstatic.com/image/thumb/Purple124/v4/c7/3d/3e/c73d3ec6-f00b-7ad2-9b5b-193683c87e80/AppIcon-0-0-1x_U007emarketing-0-0-0-7-0-0-sRGB-0-0-0-GLES2_U002c0-512MB-85-220-0-0.png/256x256bb.png" /></a></div><div class="appbox-details"><span class="appbox-name"><a href="https://apps.apple.com/br/app/starlight-mapa-do-c%C3%A9u/id762002305" target="_blank">Starlight: Mapa do Céu</a></span><span class="appbox-de">de <strong><a href="" target="_blank" class="no_icon" rel="nofollow">ION6, LLC</a></strong></span><div class="appbox-devices"><img src="https://macmagazine.com.br/wp-content/uploads/2015/11/devices_ipad.png" alt="Compat&iacute;vel com iPads" title="Compat&iacute;vel com iPads" class="appbox-devicesiPad" /><img src="https://macmagazine.com.br/wp-content/uploads/2015/11/devices_iphone.png" alt="Compat&iacute;vel com iPhones" title="Compat&iacute;vel com iPhones" class="appbox-devicesiPhone" /></div><div class="appbox-info">Vers&atilde;o <strong>3.2.6</strong> (72.1 MB)<br />
                    Requer o <strong>iOS 12.1</strong> ou superior</div></div><div class="appbox-badge"><span class="appbox-price">Gr&aacute;tis <b class="appbox-oldprice">R$ 10.90</b></span><span><a href="https://apps.apple.com/br/app/starlight-mapa-do-c%C3%A9u/id762002305" target="_blank"><img alt="Badge - Baixar na App Store" src="https://macmagazine.com.br/wp-content/uploads/2017/11/22-badge_appstore.png" class="badgeInvert" /></a></span><span class="appbox-QRcode"><a href="javascript:void(0);" title="C&oacute;digo QR - Starlight: Mapa do C&eacute;u" onclick="javascript:abrirQR('https://chart.googleapis.com/chart?chs=400x400&cht=qr&chl=https%3A%2F%2Fapps.apple.com%2Fbr%2Fapp%2Fstarlight-mapa-do-c%25C3%25A9u%2Fid762002305&chld=L|0');return false;"><img alt="C&oacute;digo QR" src="https://macmagazine.com.br/wp-content/themes/newsblock-child/images/qr.png" /></a><a href="javascript:void(0);" title="C&oacute;digo QR - Starlight: Mapa do C&eacute;u" onclick="javascript:abrirQR('https://chart.googleapis.com/chart?chs=400x400&cht=qr&chl=https%3A%2F%2Fapps.apple.com%2Fbr%2Fapp%2Fstarlight-mapa-do-c%25C3%25A9u%2Fid762002305&chld=L|0');return false;">C&oacute;digo QR</a></span></div>
                </div><p>Explore as estrelas.</p><hr /><div class="appbox"><div class="appbox-icon"><a href="https://apps.apple.com/br/app/eta-arrive-on-time/id803736422" target="_blank"><img class="appbox-iconiOS" alt="&Iacute;cone do app ETA - Arrive on time" src="https://is1-ssl.mzstatic.com/image/thumb/Purple116/v4/25/73/8e/25738efd-1604-eb79-3483-02f21296cea6/AppIcon-1x_U007emarketing-0-4-0-85-220.png/256x256bb.png" /></a></div><div class="appbox-details"><span class="appbox-name"><a href="https://apps.apple.com/br/app/eta-arrive-on-time/id803736422" target="_blank">ETA - Arrive on time</a></span><span class="appbox-de">de <strong><a href="http://whatsmyeta.co" target="_blank" class="no_icon" rel="nofollow">Eastwood</a></strong></span><div class="appbox-devices"><img src="https://macmagazine.com.br/wp-content/uploads/2015/11/devices_iphone.png" alt="Compat&iacute;vel com iPhones" title="Compat&iacute;vel com iPhones" class="appbox-devicesiPhone" /><img src="https://macmagazine.com.br/wp-content/uploads/2015/11/devices_watch.png" alt="Compat&iacute;vel com Apple Watches" title="Compat&iacute;vel com Apple Watches" class="appbox-devicesWatch" /><img src="https://macmagazine.com.br/wp-content/uploads/2017/09/16-imessage_icon.png" alt="Compat&iacute;vel com o iMessage" title="Compat&iacute;vel com o iMessage" class="appbox-iMessage" /></div><div class="appbox-info">Vers&atilde;o <strong>2.5.1</strong> (16.9 MB)<br />
                    Requer o <strong>iOS 13.0</strong> ou superior</div></div><div class="appbox-badge"><span class="appbox-price">R$ 44,90 <b class="appbox-oldprice">R$ 54.90</b></span><span><a href="https://apps.apple.com/br/app/eta-arrive-on-time/id803736422" target="_blank"><img alt="Badge - Baixar na App Store" src="https://macmagazine.com.br/wp-content/uploads/2017/11/22-badge_appstore.png" class="badgeInvert" /></a></span><span class="appbox-QRcode"><a href="javascript:void(0);" title="C&oacute;digo QR - ETA - Arrive on time" onclick="javascript:abrirQR('https://chart.googleapis.com/chart?chs=400x400&cht=qr&chl=https%3A%2F%2Fapps.apple.com%2Fbr%2Fapp%2Feta-arrive-on-time%2Fid803736422&chld=L|0');return false;"><img alt="C&oacute;digo QR" src="https://macmagazine.com.br/wp-content/themes/newsblock-child/images/qr.png" /></a><a href="javascript:void(0);" title="C&oacute;digo QR - ETA - Arrive on time" onclick="javascript:abrirQR('https://chart.googleapis.com/chart?chs=400x400&cht=qr&chl=https%3A%2F%2Fapps.apple.com%2Fbr%2Fapp%2Feta-arrive-on-time%2Fid803736422&chld=L|0');return false;">C&oacute;digo QR</a></span></div>
                </div><p>Utilitário para trânsito e direção.</p><hr /><div class="appbox"><div class="appbox-icon"><a href="https://apps.apple.com/br/app/the-christmas-list/id340779800" target="_blank"><img class="appbox-iconiOS" alt="&Iacute;cone do app The Christmas List" src="https://is1-ssl.mzstatic.com/image/thumb/Purple125/v4/67/ba/5c/67ba5caf-ca04-7e48-b9ac-a4080ab96058/AppIcon-1x_U007emarketing-0-6-0-85-220.jpeg/256x256bb.png" /></a></div><div class="appbox-details"><span class="appbox-name"><a href="https://apps.apple.com/br/app/the-christmas-list/id340779800" target="_blank">The Christmas List</a></span><span class="appbox-de">de <strong><a href="http://www.Limbua.com/" target="_blank" class="no_icon" rel="nofollow">Erik Eggleston</a></strong></span><div class="appbox-devices"><img src="https://macmagazine.com.br/wp-content/uploads/2015/11/devices_iphone.png" alt="Compat&iacute;vel com iPhones" title="Compat&iacute;vel com iPhones" class="appbox-devicesiPhone" /><img src="https://macmagazine.com.br/wp-content/uploads/2017/09/16-imessage_icon.png" alt="Compat&iacute;vel com o iMessage" title="Compat&iacute;vel com o iMessage" class="appbox-iMessage" /></div><div class="appbox-info">Vers&atilde;o <strong>4.0</strong> (14.3 MB)<br />
                    Requer o <strong>iOS 13.6</strong> ou superior</div></div><div class="appbox-badge"><span class="appbox-price">R$ 4,90 <b class="appbox-oldprice">R$ 16.90</b></span><span><a href="https://apps.apple.com/br/app/the-christmas-list/id340779800" target="_blank"><img alt="Badge - Baixar na App Store" src="https://macmagazine.com.br/wp-content/uploads/2017/11/22-badge_appstore.png" class="badgeInvert" /></a></span><span class="appbox-QRcode"><a href="javascript:void(0);" title="C&oacute;digo QR - The Christmas List" onclick="javascript:abrirQR('https://chart.googleapis.com/chart?chs=400x400&cht=qr&chl=https%3A%2F%2Fapps.apple.com%2Fbr%2Fapp%2Fthe-christmas-list%2Fid340779800&chld=L|0');return false;"><img alt="C&oacute;digo QR" src="https://macmagazine.com.br/wp-content/themes/newsblock-child/images/qr.png" /></a><a href="javascript:void(0);" title="C&oacute;digo QR - The Christmas List" onclick="javascript:abrirQR('https://chart.googleapis.com/chart?chs=400x400&cht=qr&chl=https%3A%2F%2Fapps.apple.com%2Fbr%2Fapp%2Fthe-christmas-list%2Fid340779800&chld=L|0');return false;">C&oacute;digo QR</a></span></div>
                </div><p>Utilitário para presentes de Natal.</p><h2>App para macOS</h2><hr /><div class="appbox"><div class="appbox-icon"><a href="https://apps.apple.com/br/app/total-video-player/id919402022?mt=12" target="_blank"><img alt="&Iacute;cone do app Total Video Player" src="https://is5-ssl.mzstatic.com/image/thumb/Purple125/v4/b1/5a/b6/b15ab6f3-87bb-437b-d7c8-231ed1d6d311/AppIcon-85-220-4-2x.png/256x256bb.png" /></a></div><div class="appbox-details"><span class="appbox-name"><a href="https://apps.apple.com/br/app/total-video-player/id919402022?mt=12" target="_blank">Total Video Player</a></span><span class="appbox-de">de <strong><a href="http://www.macvideostudio.com/total-video-player-mac.html" target="_blank" class="no_icon" rel="nofollow">effectmatrix</a></strong></span><div class="appbox-devices"><img src="https://macmagazine.com.br/wp-content/uploads/2015/11/devices_mac.png" alt="Compat&iacute;vel com Macs" title="Compat&iacute;vel com Macs" class="appbox-devicesMac" /></div><div class="appbox-info">Vers&atilde;o <strong>3.1.0</strong> (24.9 MB)<br />
                    Requer o <strong>macOS 10.9</strong> ou superior</div></div><div class="appbox-badge"><span class="appbox-price">R$ 54,90</span><span><a href="https://apps.apple.com/br/app/total-video-player/id919402022?mt=12" target="_blank"><img alt="Badge - Baixar na Mac App Store" src="https://macmagazine.com.br/wp-content/uploads/2017/11/22-badge_macappstore.png" class="badgeInvert" /></a></span><span class="appbox-QRcode"><a href="javascript:void(0);" title="C&oacute;digo QR - Total Video Player" onclick="javascript:abrirQR('https://chart.googleapis.com/chart?chs=400x400&cht=qr&chl=https%3A%2F%2Fapps.apple.com%2Fbr%2Fapp%2Ftotal-video-player%2Fid919402022%3Fmt%3D12&chld=L|0');return false;"><img alt="C&oacute;digo QR" src="https://macmagazine.com.br/wp-content/themes/newsblock-child/images/qr.png" /></a><a href="javascript:void(0);" title="C&oacute;digo QR - Total Video Player" onclick="javascript:abrirQR('https://chart.googleapis.com/chart?chs=400x400&cht=qr&chl=https%3A%2F%2Fapps.apple.com%2Fbr%2Fapp%2Ftotal-video-player%2Fid919402022%3Fmt%3D12&chld=L|0');return false;">C&oacute;digo QR</a></span></div>
                </div><p>Reprodutor de vídeos multiformatos.</p><hr class="wp-block-separator is-style-dots is-cnvs-separator-id-1618912657803"/><p>Aproveitem as ofertas e até amanhã. Ah, lembrando que elas são sempre por tempo limitado, então é bom correr!</p><p>Respeite o distanciamento social, use máscara (de preferência PFF2 ou N95) em ambientes fechados e vacine-se (se já chegou a sua hora de vacinar ou se chegou o momento da segunda dose ou da dose de reforço). <img src="https://s.w.org/images/core/emoji/13.1.0/72x72/1f3e0.png" alt="🏠" class="wp-smiley" style="height: 1em; max-height: 1em;" /><img src="https://s.w.org/images/core/emoji/13.1.0/72x72/1f637.png" alt="😷" class="wp-smiley" style="height: 1em; max-height: 1em;" /><img src="https://s.w.org/images/core/emoji/13.1.0/72x72/1f489.png" alt="💉" class="wp-smiley" style="height: 1em; max-height: 1em;" /></p>
]]>
</content:encoded>
<wfw:commentRss>https://macmagazine.com.br/post/2021/12/15/promocoes-na-app-store-rikudo-puzzles-starlight-total-video-player-e-mais/feed/</wfw:commentRss>
<slash:comments>0</slash:comments>
<post-id xmlns="com-wordpress:feed-additions:1">841579</post-id>
<media:content xmlns:media="http://search.yahoo.com/mrss/" medium="image" type="image/jpeg" url="https://macmagazine.com.br/wp-content/uploads/2021/12/15-Rikudo.png" width="984" height="502" />
</item>
<item>
    <title>Apple TV+ terá documentário sobre a música dos filmes de 007</title>
    <link>https://macmagazine.com.br/post/2021/12/15/apple-tv-tera-documentario-sobre-a-musica-dos-filmes-de-007/</link>
    <comments>https://macmagazine.com.br/post/2021/12/15/apple-tv-tera-documentario-sobre-a-musica-dos-filmes-de-007/#respond</comments>
    <dc:creator>
        <![CDATA[Bruno Santana]]>
    </dc:creator>
    <pubDate>Wed, 15 Dec 2021 22:35:24 +0000</pubDate>
    <category>
        <![CDATA[Apple]]>
    </category>
    <category>
        <![CDATA[Música]]>
    </category>
    <category>
        <![CDATA[Projetos]]>
    </category>
    <category>
        <![CDATA[007]]>
    </category>
    <category>
        <![CDATA[60 anos]]>
    </category>
    <category>
        <![CDATA[Apple Music]]>
    </category>
    <category>
        <![CDATA[Apple TV]]>
    </category>
    <category>
        <![CDATA[Apple TV+]]>
    </category>
    <category>
        <![CDATA[Canção]]>
    </category>
    <category>
        <![CDATA[documentário]]>
    </category>
    <category>
        <![CDATA[eon productions]]>
    </category>
    <category>
        <![CDATA[James Bond]]>
    </category>
    <category>
        <![CDATA[MGM]]>
    </category>
    <category>
        <![CDATA[the sound of 007]]>
    </category>
    <guid isPermaLink="false">https://macmagazine.com.br/?p=841559</guid>
    <description>
        <![CDATA[Depois de perder a batalha pelos direitos da franquia 007, a Apple parece ter desenvolvido uma afeição especial&#8230;]]>
    </description>
    <content:encoded>
        <![CDATA[<img width="1080" height="1080" src="https://macmagazine.com.br/wp-content/uploads/2021/12/15-apple-tv-the-sound-of-007.jpeg" class="webfeedsFeaturedVisual wp-post-image" alt="&quot;The Sound of 007&quot;" style="display: block; margin: auto; margin-bottom: 5px;max-width: 100%;" link_thumbnail="" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/15-apple-tv-the-sound-of-007.jpeg 1080w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-apple-tv-the-sound-of-007-600x600.jpeg 600w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-apple-tv-the-sound-of-007-300x300.jpeg 300w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-apple-tv-the-sound-of-007-80x80.jpeg 80w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-apple-tv-the-sound-of-007-110x110.jpeg 110w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-apple-tv-the-sound-of-007-380x380.jpeg 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-apple-tv-the-sound-of-007-800x800.jpeg 800w" sizes="(max-width: 1080px) 100vw, 1080px" /><p>Depois de <a href="https://macmagazine.com.br/post/2021/05/26/amazon-paga-mais-de-us8-bilhoes-pela-mgm-studios/">perder a batalha pelos direitos da franquia 007</a>, a Apple parece ter desenvolvido uma afeição especial por Bond,<strong>James Bond</strong>. Há alguns meses, a plataforma<a href="https://macmagazine.com.br/post/2021/09/07/documentario-ser-james-bond-ja-esta-disponivel-gratuitamente/">lançou, gratuita e exclusivamente, o documentário &#8220;Ser James Bond&#8221;</a>; agora, já temos notícias de mais um conteúdo relacionado ao icônico agente secreto britânico.</p><p><a href="https://deadline.com/2021/12/apple-documentary-music-of-james-bond-1234891760/">De acordo com o <em>Deadline</em></a>, a Maçã está planejando um documentário, atualmente intitulado <strong><em>&#8220;The Sound of 007&#8221;</em></strong>, que mergulhará em um dos aspectos mais memoráveis da franquia: a música, é claro.</p><figure class="wp-block-embed aligncenter is-type-rich is-provider-twitter wp-block-embed-twitter"><div class="wp-block-embed__wrapper"><blockquote class="twitter-tweet" data-width="550" data-dnt="true"><p lang="en" dir="ltr">To mark the 60th anniversary of the James Bond series, Apple are releasing a new documentary “The Sound of 007” in October 2022 on <a href="https://twitter.com/AppleTV?ref_src=twsrc%5Etfw">@AppleTV</a>.<a href="https://t.co/bZw2aZEWUm">pic.twitter.com/bZw2aZEWUm</a></p>&mdash; James Bond (@007) <a href="https://twitter.com/007/status/1471228227960123393?ref_src=twsrc%5Etfw">December 15, 2021</a></blockquote><script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script></div></figure><p>Uma produção conjunta da <strong>MGM</strong> (<a href="https://macmagazine.com.br/post/2021/05/26/amazon-paga-mais-de-us8-bilhoes-pela-mgm-studios/">adquirida pela Amazon</a>), da<strong>EON Productions</strong> e da<strong>Ventureland</strong>, o documentário fará uma viagem de décadas entre as origens de<em><a href="https://tv.apple.com/br/movie/007---contra-o-satanico-dr-no/umc.cmc.6m8uvpjzh34smgcyycsj35jux?at=10lt3B">&#8220;Dr. No&#8221;</a></em>, lá em 1962, até a produção de <em><a href="https://music.apple.com/br/album/no-time-to-die-single/1498647640?at=10lt3B">&#8220;No Time To Die&#8221;</a></em>, canção-tema de &#8220;007 &#8211; Sem Tempo Para Morrer&#8221; executada por <strong>Billie Eilish</strong>.</p><p>Nesse processo, pode ter certeza de que teremos a aparição de pessoas e composições eternizadas pelo tempo, como os temas compostos por <strong>John Barry</strong> e<strong>David Arnold</strong>, e clássicos como<em><a href="https://music.apple.com/br/album/live-and-let-die/1443000559?i=1443000563&amp;at=10lt3B">&#8220;Live and Let Die&#8221;</a></em>, de <strong>Paul McCartney</strong> com os Wings,<em><a href="https://music.apple.com/br/album/nobody-does-it-better/715595015?i=715595121&amp;at=10lt3B">&#8220;Nobody Does It Better&#8221;</a></em>, de <strong>Carly Simon</strong>, ou<em><a href="https://music.apple.com/br/album/skyfall-single/566322358?at=10lt3B">&#8220;Skyfall&#8221;</a></em>, de <strong>Adele</strong>. A direção será de<strong>Mat Whitecross</strong>, que comandou o documentário<em>&#8220;Coldplay: A Head Full of Dreams&#8221;</em>.</p><p><em>&#8220;The Sound of 007&#8221;</em> estreará em<strong>outubro de 2022</strong>, mês em que a saga de James Bond nos cinemas completará 60 anos. Certamente, dado o tema da produção, veremos uma combinação interessante do Apple TV+ com o Apple Music para o documentário.</p><p>Quem vai assistir? Eu, enquanto <em>bondfã</em> de carteirinha, já estou grudado na frente da TV.<img src="https://s.w.org/images/core/emoji/13.1.0/72x72/1f61c.png" alt="😜" class="wp-smiley" style="height: 1em; max-height: 1em;" /></p><p>O Apple TV+ está disponível no app Apple TV em mais de 100 países e regiões, seja em iPhones, iPads, Apple TVs, Macs, smart TVs ou online — além também estar em aparelhos como Roku, Amazon Fire TV, Chromecast com Google TV, consoles PlayStation e Xbox. O serviço <a href="https://apple.co/2Z6v2i4">custa <strong>R$9,90 por mês</strong></a>, com um período de teste gratuito de sete dias. Por tempo limitado, quem comprar e ativar um novo iPhone, iPad, Apple TV, Mac ou iPod touch ganha três meses de Apple TV+. Ele também faz parte do pacote de assinaturas da empresa, o <a href="https://macmagazine.com.br/post/2020/10/30/apple-one-esta-agora-disponivel-veja-como-assinar/">Apple One</a>.</p><hr /><div class="appbox"><div class="appbox-icon"><a href="https://apps.apple.com/br/app/apple-tv/id1174078549" target="_blank"><img class="appbox-iconiOS" alt="&Iacute;cone do app Apple TV" src="https://is5-ssl.mzstatic.com/image/thumb/Purple116/v4/42/6e/37/426e37bf-dcbd-79a1-2927-cd7889239dad/AppIcon-0-0-1x_U007emarketing-0-0-0-7-0-0-sRGB-0-0-0-GLES2_U002c0-512MB-85-220-0-0.png/256x256bb.png" /></a></div><div class="appbox-details"><span class="appbox-name"><a href="https://apps.apple.com/br/app/apple-tv/id1174078549" target="_blank">Apple TV</a></span><span class="appbox-de">de <strong><a href="https://www.apple.com/br/apple-tv-app/" target="_blank" class="no_icon" rel="nofollow">Apple</a></strong></span><div class="appbox-devices"><img src="https://macmagazine.com.br/wp-content/uploads/2015/11/devices_ipad.png" alt="Compat&iacute;vel com iPads" title="Compat&iacute;vel com iPads" class="appbox-devicesiPad" /><img src="https://macmagazine.com.br/wp-content/uploads/2015/11/devices_iphone.png" alt="Compat&iacute;vel com iPhones" title="Compat&iacute;vel com iPhones" class="appbox-devicesiPhone" /></div><div class="appbox-info">Vers&atilde;o <strong>1.7</strong> (888.8 KB)<br />
                    Requer o <strong>iOS 10.2</strong> ou superior</div></div><div class="appbox-badge"><span class="appbox-price">Gr&aacute;tis</span><span><a href="https://apps.apple.com/br/app/apple-tv/id1174078549" target="_blank"><img alt="Badge - Baixar na App Store" src="https://macmagazine.com.br/wp-content/uploads/2017/11/22-badge_appstore.png" class="badgeInvert" /></a></span><span class="appbox-QRcode"><a href="javascript:void(0);" title="C&oacute;digo QR - Apple TV" onclick="javascript:abrirQR('https://chart.googleapis.com/chart?chs=400x400&cht=qr&chl=https%3A%2F%2Fapps.apple.com%2Fbr%2Fapp%2Fapple-tv%2Fid1174078549&chld=L|0');return false;"><img alt="C&oacute;digo QR" src="https://macmagazine.com.br/wp-content/themes/newsblock-child/images/qr.png" /></a><a href="javascript:void(0);" title="C&oacute;digo QR - Apple TV" onclick="javascript:abrirQR('https://chart.googleapis.com/chart?chs=400x400&cht=qr&chl=https%3A%2F%2Fapps.apple.com%2Fbr%2Fapp%2Fapple-tv%2Fid1174078549&chld=L|0');return false;">C&oacute;digo QR</a></span></div>
                </div>
]]>
</content:encoded>
<wfw:commentRss>https://macmagazine.com.br/post/2021/12/15/apple-tv-tera-documentario-sobre-a-musica-dos-filmes-de-007/feed/</wfw:commentRss>
<slash:comments>0</slash:comments>
<post-id xmlns="com-wordpress:feed-additions:1">841559</post-id>
<media:content xmlns:media="http://search.yahoo.com/mrss/" medium="image" type="image/jpeg" url="https://macmagazine.com.br/wp-content/uploads/2021/12/15-apple-tv-the-sound-of-007.jpeg" width="1080" height="1080" />
</item>
<item>
    <title>Apple fecha 3 lojas de uma vez após novos surtos de COVID-19</title>
    <link>https://macmagazine.com.br/post/2021/12/15/apple-fecha-3-lojas-de-uma-vez-apos-novos-surtos-de-covid-19/</link>
    <comments>https://macmagazine.com.br/post/2021/12/15/apple-fecha-3-lojas-de-uma-vez-apos-novos-surtos-de-covid-19/#respond</comments>
    <dc:creator>
        <![CDATA[Douglas Nascimento]]>
    </dc:creator>
    <pubDate>Wed, 15 Dec 2021 22:06:00 +0000</pubDate>
    <category>
        <![CDATA[Apple]]>
    </category>
    <category>
        <![CDATA[Off-Topic]]>
    </category>
    <category>
        <![CDATA[Annapolis]]>
    </category>
    <category>
        <![CDATA[Apple Store]]>
    </category>
    <category>
        <![CDATA[Apple Stores]]>
    </category>
    <category>
        <![CDATA[Brickell City Center]]>
    </category>
    <category>
        <![CDATA[Canadá]]>
    </category>
    <category>
        <![CDATA[COVID]]>
    </category>
    <category>
        <![CDATA[COVID-19]]>
    </category>
    <category>
        <![CDATA[Estados Unidos]]>
    </category>
    <category>
        <![CDATA[EUA]]>
    </category>
    <category>
        <![CDATA[Fechada]]>
    </category>
    <category>
        <![CDATA[Flórida]]>
    </category>
    <category>
        <![CDATA[lojas]]>
    </category>
    <category>
        <![CDATA[Maryland]]>
    </category>
    <category>
        <![CDATA[miami]]>
    </category>
    <category>
        <![CDATA[Ômicron]]>
    </category>
    <category>
        <![CDATA[Ottawa]]>
    </category>
    <category>
        <![CDATA[pandemia]]>
    </category>
    <guid isPermaLink="false">https://macmagazine.com.br/?p=841509</guid>
    <description>
        <![CDATA[Quando a gente achava que a situação envolvendo a pandemia da COVID-19 estaria majoritariamente controlada neste fim de&#8230;]]>
    </description>
    <content:encoded>
        <![CDATA[<img width="1200" height="800" src="https://macmagazine.com.br/wp-content/uploads/2021/12/15-loja-apple-covid-19-1260x840.jpg" class="webfeedsFeaturedVisual wp-post-image" alt="Loja da Apple fechada por conta da pandemia da COVID-19" style="display: block; margin: auto; margin-bottom: 5px;max-width: 100%;" link_thumbnail="" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/15-loja-apple-covid-19-1260x840.jpg 1260w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-loja-apple-covid-19-600x400.jpg 600w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-loja-apple-covid-19-300x200.jpg 300w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-loja-apple-covid-19-1536x1024.jpg 1536w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-loja-apple-covid-19-2048x1365.jpg 2048w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-loja-apple-covid-19-380x253.jpg 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-loja-apple-covid-19-800x533.jpg 800w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-loja-apple-covid-19-1160x773.jpg 1160w" sizes="(max-width: 1200px) 100vw, 1200px" /><p>Quando a gente achava que a situação envolvendo a pandemia da <strong>COVID-19</strong> estaria majoritariamente controlada neste fim de ano, não é bem isso que vem acontecendo. Nos Estados Unidos, por exemplo, a não vacinação por parte de parcela da população, bem como a disseminação da variante<strong>Ômicron</strong>, vêm promovendo novos surtos do vírus pelo país.</p><p>A <strong>Apple</strong>, inclusive, teve de fechar agora três lojas de varejo nos EUA e no Canadá após novos surtos da doença<strong> </strong>em<strong>Miami</strong> (Flórida),<strong>Annapolis</strong> (Maryland) e<strong>Ottawa</strong> (Canadá).</p><p>O fechamento das lojas se deu devido ao aumento dos casos internos e deverá durar alguns dias, tempo necessário para que todos os funcionários façam testes de COVID-19 e para que tudo seja restabelecido com segurança.</p><p>Em comunicado, a Apple afirmou que monitora regularmente as condições de trabalho e que ajustará suas &#8220;medidas de saúde para apoiar o bem-estar dos clientes e funcionários&#8221;, deixando claro que tomará todos os cuidados necessários para manter tudo seguro:</p><blockquote class="wp-block-quote"><p>Continuamos comprometidos com uma abordagem abrangente para nossas equipes que combina testes regulares com verificações diárias de saúde, mascaramento de funcionários e clientes, limpeza profunda e licença médica remunerada.</p></blockquote><p><a href="https://www.bloomberg.com/news/articles/2021-12-15/apple-temporarily-shuts-three-retail-stores-after-covid-19-surge">De acordo com a <em>Bloomberg</em></a>, a Apple só havia precisado fechar uma loja de cada vez desde a reabertura total, no início deste ano, nunca mais que isso. Na semana passada, por exemplo, <a href="https://macmagazine.com.br/post/2021/12/09/loja-da-apple-no-texas-fecha-apos-casos-de-covid-19-na-equipe/">a empresa fechou uma loja no Texas</a> pelo mesmo motivo.</p><p>A empresa, vale recordar, vem fazendo de tudo para impedir esse tipo de problema. Recentemente, por exemplo, ela passou a <a href="https://macmagazine.com.br/post/2021/10/20/apple-exigira-testes-mais-frequentes-de-funcionarios-nao-vacinados/">exigir testes rápidos dos funcionários periodicamente</a> e orienta aos que tenham sintomas que permaneçam em casa.</p>
]]>
</content:encoded>
<wfw:commentRss>https://macmagazine.com.br/post/2021/12/15/apple-fecha-3-lojas-de-uma-vez-apos-novos-surtos-de-covid-19/feed/</wfw:commentRss>
<slash:comments>0</slash:comments>
<post-id xmlns="com-wordpress:feed-additions:1">841509</post-id>
<media:content xmlns:media="http://search.yahoo.com/mrss/" medium="image" type="image/jpeg" url="https://macmagazine.com.br/wp-content/uploads/2021/12/15-loja-apple-covid-19-1260x840.jpg" width="1200" height="800" />
</item>
<item>
    <title>Apple e LG estariam trabalhando em sucessor do Pro Display XDR</title>
    <link>https://macmagazine.com.br/post/2021/12/15/apple-e-lg-estariam-trabalhando-em-sucessor-do-pro-display-xdr/</link>
    <comments>https://macmagazine.com.br/post/2021/12/15/apple-e-lg-estariam-trabalhando-em-sucessor-do-pro-display-xdr/#respond</comments>
    <dc:creator>
        <![CDATA[Bruno Cardoso]]>
    </dc:creator>
    <pubDate>Wed, 15 Dec 2021 21:52:11 +0000</pubDate>
    <category>
        <![CDATA[Apple]]>
    </category>
    <category>
        <![CDATA[Hardware]]>
    </category>
    <category>
        <![CDATA[Rumores]]>
    </category>
    <category>
        <![CDATA[120Hz]]>
    </category>
    <category>
        <![CDATA[dylandkt]]>
    </category>
    <category>
        <![CDATA[leaker]]>
    </category>
    <category>
        <![CDATA[LG]]>
    </category>
    <category>
        <![CDATA[Mac]]>
    </category>
    <category>
        <![CDATA[Mini-LED]]>
    </category>
    <category>
        <![CDATA[Monitor]]>
    </category>
    <category>
        <![CDATA[Monitor profissional]]>
    </category>
    <category>
        <![CDATA[Pro Display XDR]]>
    </category>
    <category>
        <![CDATA[ProMotion]]>
    </category>
    <category>
        <![CDATA[Thunderbolt Display]]>
    </category>
    <category>
        <![CDATA[vazamentos]]>
    </category>
    <guid isPermaLink="false">https://macmagazine.com.br/?p=841507</guid>
    <description>
        <![CDATA[Novos rumores apontam que a LG pode estar desenvolvendo um sucessor do Pro Display XDR, da Apple, além&#8230;]]>
    </description>
    <content:encoded>
        <![CDATA[<img width="1038" height="1260" src="https://macmagazine.com.br/wp-content/uploads/2021/12/15-pro-display-xdr-1038x1260.jpg" class="webfeedsFeaturedVisual wp-post-image" alt="Pro Display XDR" style="display: block; margin: auto; margin-bottom: 5px;max-width: 100%;" link_thumbnail="" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/15-pro-display-xdr-1038x1260.jpg 1038w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-pro-display-xdr-494x600.jpg 494w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-pro-display-xdr-247x300.jpg 247w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-pro-display-xdr-1265x1536.jpg 1265w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-pro-display-xdr-1687x2048.jpg 1687w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-pro-display-xdr-380x461.jpg 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-pro-display-xdr-800x971.jpg 800w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-pro-display-xdr-1160x1408.jpg 1160w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-pro-display-xdr-scaled.jpg 3374w" sizes="(max-width: 1038px) 100vw, 1038px" /><p>Novos rumores apontam que a <strong>LG </strong>pode estar desenvolvendo um sucessor do<strong>Pro Display XDR</strong>, da<strong>Apple</strong>, além de dois novos monitores de entrada para a companhia — aos moldes do antigo Thunderbolt Display,<a href="https://macmagazine.com.br/post/2016/06/23/apos-cinco-anos-sem-atualizacao-apple-oficializa-a-morte-do-thunderbolt-display/">descontinuado em 2016</a>.</p><p>Segundo o <em>leaker</em><a href="https://twitter.com/dylandkt">@dylandkt</a>, a empresa sul-coreana estaria desenvolvendo dois monitores (um de 24 e outro de 27 polegadas) baseados no novo iMac de 24&#8243;, apresentado pela Apple em abril. Além disso, um outro display de 32&#8243;, similar ao atual Pro Display XDR, também teria sido &#8220;flagrado&#8221; pelo<em>leaker</em>.</p><figure class="wp-block-embed aligncenter is-type-rich is-provider-twitter wp-block-embed-twitter"><div class="wp-block-embed__wrapper"><blockquote class="twitter-tweet" data-width="550" data-dnt="true"><p lang="en" dir="ltr"><img src="https://s.w.org/images/core/emoji/13.1.0/72x72/1f9f5.png" alt="🧵" class="wp-smiley" style="height: 1em; max-height: 1em;" />Thread 1/4: There are three LG made Displays encased in unbranded enclosures for usage as external monitors that are in early development. Two of which have the same specifications as the upcoming 27 inch and current 24 inch iMac displays.</p>&mdash; Dylan (@dylandkt) <a href="https://twitter.com/dylandkt/status/1471186599547490312?ref_src=twsrc%5Etfw">December 15, 2021</a></blockquote><script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script></div></figure><p>Em tweets, Dylan afirma que os três monitores estão, atualmente, montados em carcaças sem nenhuma identificação ou logo, mas que considera seguro acreditar que pelo menos um deles se trate de um produto destinado à Maçã, uma vez que a versão de 32&#8243; parece contar um chip da Apple não especificado.</p><figure class="wp-block-embed aligncenter is-type-rich is-provider-twitter wp-block-embed-twitter"><div class="wp-block-embed__wrapper"><blockquote class="twitter-tweet" data-width="550" data-dnt="true"><p lang="en" dir="ltr">Thread 2/4: The other display seems to be an improved 32 inch Pro Display XDR. Despite the lack of branding, It can be assumed at the very least that this display will be Apple branded.</p>&mdash; Dylan (@dylandkt)<a href="https://twitter.com/dylandkt/status/1471186760965238792?ref_src=twsrc%5Etfw">December 15, 2021</a></blockquote><script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script></div></figure><p>Vale lembrar que, <a href="https://macmagazine.com.br/post/2021/07/23/apple-estaria-trabalhando-em-novo-monitor-com-chip-a13-e-neural-engine/">em julho</a>, surgiram rumores de que a Apple estaria trabalhando em um novo monitor profissional que contaria com o chip<strong>A13 Bionic</strong> e<strong>Neural Engine</strong>. Tal característica seria capaz de tornar o monitor ainda mais rápido ou, até mesmo, melhorar a performance gráfica de Macs. Dylan, contudo, não confirmou se esse modelo se trata do mesmo desenvolvido pela LG.</p><p>Além disso, tanto o monitor de 32&#8243; quanto o de 27&#8243; parecem contar com telas <strong>Mini-LED</strong> compatíveis com a tecnologia<strong>ProMotion</strong>, que permite taxas de atualização variáveis de até 120Hz.</p><p>Embora o <em>leaker</em> tenha um histórico relativamente curto de previsões relacionadas aos produtos Apple, seus vazamentos costumam ter um alto grau de precisão. Dylan é conhecido, por exemplo, por ter previsto a chegada do chip M1 ao iPads Pro e as webcams Full HD (1080p) nos novos MacBooks Pro.</p><p>Veremos…</p><hr><div class="appbox"><div class="appbox-icon"><a href="https://apple.sjv.io/eM6dj"><img width="600" height="495" src="https://macmagazine.com.br/wp-content/uploads/2021/04/12-pro-display-xdr-600x495.jpeg" alt="Pro Display XDR" class="wp-image-776146" srcset="https://macmagazine.com.br/wp-content/uploads/2021/04/12-pro-display-xdr-600x495.jpeg 600w, https://macmagazine.com.br/wp-content/uploads/2021/04/12-pro-display-xdr-1260x1039.jpeg 1260w, https://macmagazine.com.br/wp-content/uploads/2021/04/12-pro-display-xdr-300x247.jpeg 300w, https://macmagazine.com.br/wp-content/uploads/2021/04/12-pro-display-xdr-1536x1267.jpeg 1536w, https://macmagazine.com.br/wp-content/uploads/2021/04/12-pro-display-xdr-2048x1689.jpeg 2048w, https://macmagazine.com.br/wp-content/uploads/2021/04/12-pro-display-xdr-380x313.jpeg 380w, https://macmagazine.com.br/wp-content/uploads/2021/04/12-pro-display-xdr-800x660.jpeg 800w, https://macmagazine.com.br/wp-content/uploads/2021/04/12-pro-display-xdr-1160x957.jpeg 1160w, https://macmagazine.com.br/wp-content/uploads/2021/04/12-pro-display-xdr.jpeg 2832w" sizes="(max-width: 600px) 100vw, 600px" /></a></div><div class="appbox-details"><span class="appbox-name"><a href="https://apple.sjv.io/eM6dj">Pro Display XDR</a></span><span class="appbox-de">de <strong>Apple</strong></span><span><small><strong>Preço à vista:</strong> a partir de R$40.499,10<br><strong>Preço parcelado:</strong> em até 12x de R$3.749,92<br><strong>Lançamento:</strong> 2019</small></span></div><div class="appbox-badge"><span style="float: right;"><a href="https://apple.sjv.io/eM6dj" class="botaoComprar">Comprar</a></span></div></div><p class="notaTransparencia">NOTA DE TRANSPARÊNCIA: O <strong><em>MacMagazine</em></strong> recebe uma pequena comissão de vendas concluídas por meio de links deste post, mas você, como consumidor, não paga nada mais pelos produtos comprando pelos nossos links de afiliado.</p>
]]>
</content:encoded>
<wfw:commentRss>https://macmagazine.com.br/post/2021/12/15/apple-e-lg-estariam-trabalhando-em-sucessor-do-pro-display-xdr/feed/</wfw:commentRss>
<slash:comments>0</slash:comments>
<post-id xmlns="com-wordpress:feed-additions:1">841507</post-id>
<media:content xmlns:media="http://search.yahoo.com/mrss/" medium="image" type="image/jpeg" url="https://macmagazine.com.br/wp-content/uploads/2021/12/15-pro-display-xdr-1038x1260.jpg" width="1038" height="1260" />
</item>
<item>
    <title>Brasil foi o 3º país que mais baixou apps em 2021</title>
    <link>https://macmagazine.com.br/post/2021/12/15/brasil-foi-o-3o-pais-que-mais-baixou-apps-em-2021/</link>
    <comments>https://macmagazine.com.br/post/2021/12/15/brasil-foi-o-3o-pais-que-mais-baixou-apps-em-2021/#respond</comments>
    <dc:creator>
        <![CDATA[Bruno Cardoso]]>
    </dc:creator>
    <pubDate>Wed, 15 Dec 2021 20:56:35 +0000</pubDate>
    <category>
        <![CDATA[Gadgets]]>
    </category>
    <category>
        <![CDATA[Jogos]]>
    </category>
    <category>
        <![CDATA[Pesquisa]]>
    </category>
    <category>
        <![CDATA[Software]]>
    </category>
    <category>
        <![CDATA[Android]]>
    </category>
    <category>
        <![CDATA[aplicativos]]>
    </category>
    <category>
        <![CDATA[app]]>
    </category>
    <category>
        <![CDATA[App Annie]]>
    </category>
    <category>
        <![CDATA[App Store]]>
    </category>
    <category>
        <![CDATA[apps]]>
    </category>
    <category>
        <![CDATA[Discord]]>
    </category>
    <category>
        <![CDATA[downloads]]>
    </category>
    <category>
        <![CDATA[Google Play]]>
    </category>
    <category>
        <![CDATA[iOS]]>
    </category>
    <category>
        <![CDATA[iPhone]]>
    </category>
    <category>
        <![CDATA[Pesquisa de Mercado]]>
    </category>
    <category>
        <![CDATA[ranking]]>
    </category>
    <category>
        <![CDATA[Telegram]]>
    </category>
    <category>
        <![CDATA[TikTok]]>
    </category>
    <guid isPermaLink="false">https://macmagazine.com.br/?p=841453</guid>
    <description>
        <![CDATA[A App Annie divulgou a nova versão do seu tradicional relatório sobre o mercado de apps. Dessa vez,&#8230;]]>
    </description>
    <content:encoded>
        <![CDATA[<img width="1200" height="800" src="https://macmagazine.com.br/wp-content/uploads/2021/07/23-apps-de-redes-sociais-1260x840.jpg" class="webfeedsFeaturedVisual wp-post-image" alt="Ícones de apps (Snapchat, Instagram, Facebook, YouTube, WhatsApp, Twitter, TikTok, Reddit, Telegram e Zoom)" style="display: block; margin: auto; margin-bottom: 5px;max-width: 100%;" link_thumbnail="" srcset="https://macmagazine.com.br/wp-content/uploads/2021/07/23-apps-de-redes-sociais-1260x840.jpg 1260w, https://macmagazine.com.br/wp-content/uploads/2021/07/23-apps-de-redes-sociais-600x400.jpg 600w, https://macmagazine.com.br/wp-content/uploads/2021/07/23-apps-de-redes-sociais-300x200.jpg 300w, https://macmagazine.com.br/wp-content/uploads/2021/07/23-apps-de-redes-sociais-1536x1024.jpg 1536w, https://macmagazine.com.br/wp-content/uploads/2021/07/23-apps-de-redes-sociais-2048x1365.jpg 2048w, https://macmagazine.com.br/wp-content/uploads/2021/07/23-apps-de-redes-sociais-380x253.jpg 380w, https://macmagazine.com.br/wp-content/uploads/2021/07/23-apps-de-redes-sociais-800x533.jpg 800w, https://macmagazine.com.br/wp-content/uploads/2021/07/23-apps-de-redes-sociais-1160x773.jpg 1160w" sizes="(max-width: 1200px) 100vw, 1200px" /><p>A <strong>App Annie</strong> divulgou a nova versão do seu tradicional<a href="https://www.appannie.com/en/insights/market-data/2021-end-year-mobile-apps-recap/">relatório sobre o mercado de apps</a>. Dessa vez, os dados referentes ao ano de 2021 chegam com métricas animadoras para o aplicativo de mensagens<strong>Telegram</strong>, que sofreu um grande aumento no número de usuários ativos mensalmente.</p><p>De acordo com a pesquisa, o Telegram foi o app que obteve o maior crescimento relativo em comparação ao ano passado, à frente de outros gigantes do mercado como o <strong>Instagram</strong> e o<strong>Zoom</strong> (que permanece forte desde seu sucesso inicial, em 2020).</p><div class="wp-block-image"><figure class="aligncenter size-large"><a href="https://macmagazine.com.br/wp-content/uploads/2021/12/15-TopApps-AppAnnie.png"><img width="1260" height="712" src="https://macmagazine.com.br/wp-content/uploads/2021/12/15-TopApps-AppAnnie-1260x712.png" alt="" class="wp-image-841488" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/15-TopApps-AppAnnie-1260x712.png 1260w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-TopApps-AppAnnie-600x339.png 600w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-TopApps-AppAnnie-300x170.png 300w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-TopApps-AppAnnie-1536x869.png 1536w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-TopApps-AppAnnie-2048x1158.png 2048w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-TopApps-AppAnnie-380x215.png 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-TopApps-AppAnnie-800x452.png 800w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-TopApps-AppAnnie-1160x656.png 1160w" sizes="(max-width: 1260px) 100vw, 1260px" /></a></figure></div><p>O CEO<span id='easy-footnote-1-841453' class='easy-footnote-margin-adjust'></span><span class='easy-footnote'><a href='https://macmagazine.com.br/post/2021/12/15/brasil-foi-o-3o-pais-que-mais-baixou-apps-em-2021/#easy-footnote-bottom-1-841453' title='&lt;em&gt;Chief executive officer&lt;/em&gt;, ou diretor executivo.'><sup>1</sup></a></span> do mensageiro, <strong>Pavel Durov</strong>, comemorou o marco em seu canal pessoal no Telegram, onde divulgou uma mensagem de agradecimento e aproveitou para alfinetar a concorrência:</p><blockquote class="wp-block-quote"><p>As pessoas não querem mais trocar sua privacidade por serviços gratuitos. Eles não querem mais ser reféns de monopólios de tecnologia que parecem pensar que podem se safar de qualquer coisa, desde que seus aplicativos tenham uma massa crítica de usuários. Com meio bilhão de usuários ativos e crescimento acelerado, o Telegram se tornou o maior refúgio para quem busca uma plataforma de comunicação comprometida com a privacidade e a segurança. Levamos essa responsabilidade muito a sério. Não vamos decepcionar vocês.</p></blockquote><h2>Apps de redes sociais</h2><p>Entre os aplicativos de redes sociais, o <strong>TikTok</strong> aparece soberano em todas as listas levantadas pela pesquisa, figurando como o app mais popular tanto globalmente, quanto em mercados populares como os Estados Unidos e o Reino Unido. Os apps de transmissões ao vivo<strong>BIGO LIVE</strong> e de chamadas online<strong>Discord</strong> vêm logo atrás.</p><div class="wp-block-image"><figure class="aligncenter size-large"><a href="https://macmagazine.com.br/wp-content/uploads/2021/12/15-SocialApps-AppAnnie.png"><img width="1260" height="712" src="https://macmagazine.com.br/wp-content/uploads/2021/12/15-SocialApps-AppAnnie-1260x712.png" alt="" class="wp-image-841489" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/15-SocialApps-AppAnnie-1260x712.png 1260w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-SocialApps-AppAnnie-600x339.png 600w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-SocialApps-AppAnnie-300x170.png 300w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-SocialApps-AppAnnie-1536x869.png 1536w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-SocialApps-AppAnnie-2048x1158.png 2048w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-SocialApps-AppAnnie-380x215.png 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-SocialApps-AppAnnie-800x452.png 800w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-SocialApps-AppAnnie-1160x656.png 1160w" sizes="(max-width: 1260px) 100vw, 1260px" /></a></figure></div><p>O único app da <strong>Meta </strong>a aparecer nos rankings foi o<strong>Facebook</strong>, que ficou na quarta colocação tanto globalmente quanto em solo britânico. Nos EUA, a rede de Mark Zuckerberg apareceu na oitava posição.</p><p>Ainda segundo a App Annie, é esperado que o setor de aplicativos sociais lucre cerca de US$9 bilhões em 2022 — um aumento de 82% em relação a 2021.</p><h2>Serviços de streaming</h2><p>O <strong>YouTube </strong>manteve sua liderança no ranking global de apps de streaming, aparecendo como o serviço mais popular entre os usuários de iOS e Android. Mesmo assim, o serviço de vídeos do Google não conseguiu estabelecer sua hegemonia em sua terra natal e nem no Reino Unido, onde sequer apareceu no<em>Top 10</em>.</p><div class="wp-block-image"><figure class="aligncenter size-large"><a href="https://macmagazine.com.br/wp-content/uploads/2021/12/15-StreamingApps-AppAnnie.png"><img width="1260" height="712" src="https://macmagazine.com.br/wp-content/uploads/2021/12/15-StreamingApps-AppAnnie-1260x712.png" alt="" class="wp-image-841490" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/15-StreamingApps-AppAnnie-1260x712.png 1260w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-StreamingApps-AppAnnie-600x339.png 600w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-StreamingApps-AppAnnie-300x170.png 300w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-StreamingApps-AppAnnie-1536x869.png 1536w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-StreamingApps-AppAnnie-2048x1158.png 2048w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-StreamingApps-AppAnnie-380x215.png 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-StreamingApps-AppAnnie-800x452.png 800w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-StreamingApps-AppAnnie-1160x656.png 1160w" sizes="(max-width: 1260px) 100vw, 1260px" /></a></figure></div><p>Além disso, a pesquisa ressaltou o bom desempenho do HBO Max e, especialmente, do Disney+. Segundo os dados, os assinantes do serviço da empresa do Mickey passaram cerca de 975 bilhões de horas acumuladas assistindo aos filmes e séries da empresa.</p><h2>Jogos mobile</h2><p>Entre os destaques dos jogos mais populares do último ano está <strong>Bridge Race</strong>, que se estabeleceu como o jogo mobile mais baixado mundialmente, seguido por<strong>Hair Challenge</strong> e<strong>Count Masters</strong>.</p><div class="wp-block-image"><figure class="aligncenter size-large"><a href="https://macmagazine.com.br/wp-content/uploads/2021/12/15-Games-AppAnnie.jpg"><img width="1260" height="713" src="https://macmagazine.com.br/wp-content/uploads/2021/12/15-Games-AppAnnie-1260x713.jpg" alt="" class="wp-image-841491" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/15-Games-AppAnnie-1260x713.jpg 1260w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-Games-AppAnnie-600x339.jpg 600w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-Games-AppAnnie-300x170.jpg 300w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-Games-AppAnnie-1536x869.jpg 1536w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-Games-AppAnnie-380x215.jpg 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-Games-AppAnnie-800x453.jpg 800w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-Games-AppAnnie-1160x656.jpg 1160w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-Games-AppAnnie.jpg 1600w" sizes="(max-width: 1260px) 100vw, 1260px" /></a></figure></div><p>Ademais, os gêneros de jogos mais populares entre os gamers mobile foram de estratégia, RPG e simulação, os quais obtiveram crescimentos de 32%, 21% e 57% em relação ao ano passado, respectivamente.</p><p>Por fim, usuários de iOS e Android baixaram, combinados, mais de 140 bilhões de apps no geral — a <strong>Índia</strong> lidera essa marca com 20% do total, seguida pelos<strong>EUA</strong> com 9% e pelo<strong>Brasil</strong> com 8%.</p><p><span class="credito">via <a href="https://www.uol.com.br/tilt/noticias/redacao/2021/12/15/bombou-telegram-foi-o-app-que-mais-cresceu-em-2021-diz-ibope-dos-apps.htm">UOL Tilt</a></span></p>
]]>
</content:encoded>
<wfw:commentRss>https://macmagazine.com.br/post/2021/12/15/brasil-foi-o-3o-pais-que-mais-baixou-apps-em-2021/feed/</wfw:commentRss>
<slash:comments>0</slash:comments>
<post-id xmlns="com-wordpress:feed-additions:1">841453</post-id>
<media:content xmlns:media="http://search.yahoo.com/mrss/" medium="image" type="image/jpeg" url="https://macmagazine.com.br/wp-content/uploads/2021/07/23-apps-de-redes-sociais-1260x840.jpg" width="1200" height="800" />
</item>
<item>
    <title>Google Drive alertará sobre arquivos marcados como spam</title>
    <link>https://macmagazine.com.br/post/2021/12/15/google-drive-alertara-sobre-arquivos-marcados-como-spam/</link>
    <comments>https://macmagazine.com.br/post/2021/12/15/google-drive-alertara-sobre-arquivos-marcados-como-spam/#respond</comments>
    <dc:creator>
        <![CDATA[Douglas Nascimento]]>
    </dc:creator>
    <pubDate>Wed, 15 Dec 2021 20:44:41 +0000</pubDate>
    <category>
        <![CDATA[Internet]]>
    </category>
    <category>
        <![CDATA[Segurança]]>
    </category>
    <category>
        <![CDATA[Software]]>
    </category>
    <category>
        <![CDATA[aplicativos]]>
    </category>
    <category>
        <![CDATA[app]]>
    </category>
    <category>
        <![CDATA[App Store]]>
    </category>
    <category>
        <![CDATA[apps]]>
    </category>
    <category>
        <![CDATA[atualização]]>
    </category>
    <category>
        <![CDATA[Google Drive]]>
    </category>
    <category>
        <![CDATA[Google workspace]]>
    </category>
    <category>
        <![CDATA[iOS]]>
    </category>
    <category>
        <![CDATA[política]]>
    </category>
    <category>
        <![CDATA[spam]]>
    </category>
    <guid isPermaLink="false">https://macmagazine.com.br/?p=841480</guid>
    <description>
        <![CDATA[O compartilhamento de spam no Google Drive se tornou uma das maiores preocupações para o Google nos últimos&#8230;]]>
    </description>
    <content:encoded>
        <![CDATA[<img width="1200" height="500" src="https://macmagazine.com.br/wp-content/uploads/2020/10/06-Google-Workspace-1260x525.png" class="webfeedsFeaturedVisual wp-post-image" alt="Google Workspace" style="display: block; margin: auto; margin-bottom: 5px;max-width: 100%;" link_thumbnail="" srcset="https://macmagazine.com.br/wp-content/uploads/2020/10/06-Google-Workspace-1260x525.png 1260w, https://macmagazine.com.br/wp-content/uploads/2020/10/06-Google-Workspace-600x250.png 600w, https://macmagazine.com.br/wp-content/uploads/2020/10/06-Google-Workspace-300x125.png 300w, https://macmagazine.com.br/wp-content/uploads/2020/10/06-Google-Workspace-1536x640.png 1536w, https://macmagazine.com.br/wp-content/uploads/2020/10/06-Google-Workspace-2048x854.png 2048w, https://macmagazine.com.br/wp-content/uploads/2020/10/06-Google-Workspace.png 2200w" sizes="(max-width: 1200px) 100vw, 1200px" /><p>O compartilhamento de spam<span id='easy-footnote-1-841480' class='easy-footnote-margin-adjust'></span><span class='easy-footnote'><a href='https://macmagazine.com.br/post/2021/12/15/google-drive-alertara-sobre-arquivos-marcados-como-spam/#easy-footnote-bottom-1-841480' title='&lt;em&gt;Sending and posting advertisement in mass&lt;/em&gt;, ou enviar e postar publicidade em massa.'><sup>1</sup></a></span> no <strong>Google Drive</strong> se tornou uma das maiores preocupações para o Google nos últimos anos, e é por isso que a empresa anunciou ontem uma<a href="https://workspaceupdates.googleblog.com/2021/12/abuse-notification-emails-google-drive.html">nova atualização do <strong>Workspace</strong></a> para tentar amenizar esse problema.</p><p>Embora o Google tenha passado a permitir denunciar arquivos que ferem sua política contra spam, isso de pouco adiantou. Além de a medida não ser tão efetiva, ela ainda possibilitou que o compartilhamento de alguns arquivos &#8220;inocentes&#8221; fosse prejudicado com falsas sinalizações.</p><p>Agora, além de impedir o compartilhamento de arquivos que supostamente ferem sua política, a empresa avisará aos proprietários (por email) quando os itens armazenados no Drive forem sinalizados.</p><div class="wp-block-image"><figure class="aligncenter size-large"><a href="https://macmagazine.com.br/wp-content/uploads/2021/12/15-email-google.png"><img width="1260" height="672" src="https://macmagazine.com.br/wp-content/uploads/2021/12/15-email-google-1260x672.png" alt="Email enviado pelo Google" class="wp-image-841496" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/15-email-google-1260x672.png 1260w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-email-google-600x320.png 600w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-email-google-300x160.png 300w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-email-google-1536x819.png 1536w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-email-google-2048x1092.png 2048w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-email-google-380x203.png 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-email-google-800x427.png 800w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-email-google-1160x619.png 1160w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-email-google-1920x1024.png 1920w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-email-google.png 2224w" sizes="(max-width: 1260px) 100vw, 1260px" /></a></figure></div><p>Funcionará assim: quando um arquivo for detectado como suspeito, ele ganhará uma bandeira sinalizando que há algo de errado e será restrito, mas não excluído por completo. Isso significa que apenas o proprietário conseguirá acessá-lo, mas o item não poderá ser compartilhado e não ficará visível nem mesmo para as pessoas que já tiverem acesso ao link.</p><p>Além disso, como já mencionado, o dono desse arquivo receberá um email com detalhes e possíveis medicas que poderão ser tomadas para que seja solicitada uma revisão.</p><p>De acordo com o Google, isso ajudará a garantir que os proprietários desses itens no Google Drive estejam totalmente informados sobre o status dos seus arquivos e, ao mesmo tempo, garantirá que outros usuários estejam protegidos contra conteúdos abusivos.</p><hr /><div class="appbox"><div class="appbox-icon"><a href="https://apps.apple.com/br/app/google-drive-armazenamento/id507874739" target="_blank"><img class="appbox-iconiOS" alt="&Iacute;cone do app Google Drive - armazenamento" src="https://is2-ssl.mzstatic.com/image/thumb/Purple116/v4/bb/d9/d6/bbd9d687-6161-870c-d843-3be99480f039/AppIcon-0-1x_U007emarketing-0-6-0-0-0-85-220.png/256x256bb.png" /></a></div><div class="appbox-details"><span class="appbox-name"><a href="https://apps.apple.com/br/app/google-drive-armazenamento/id507874739" target="_blank">Google Drive - armazenamento</a></span><span class="appbox-de">de <strong><a href="http://drive.google.com/start" target="_blank" class="no_icon" rel="nofollow">Google LLC</a></strong></span><div class="appbox-devices"><img src="https://macmagazine.com.br/wp-content/uploads/2015/11/devices_ipad.png" alt="Compat&iacute;vel com iPads" title="Compat&iacute;vel com iPads" class="appbox-devicesiPad" /><img src="https://macmagazine.com.br/wp-content/uploads/2015/11/devices_iphone.png" alt="Compat&iacute;vel com iPhones" title="Compat&iacute;vel com iPhones" class="appbox-devicesiPhone" /></div><div class="appbox-info">Vers&atilde;o <strong>4.2021.48202</strong> (238.9 MB)<br />
                    Requer o <strong>iOS 13.0</strong> ou superior</div></div><div class="appbox-badge"><span class="appbox-price">Gr&aacute;tis</span><span><a href="https://apps.apple.com/br/app/google-drive-armazenamento/id507874739" target="_blank"><img alt="Badge - Baixar na App Store" src="https://macmagazine.com.br/wp-content/uploads/2017/11/22-badge_appstore.png" class="badgeInvert" /></a></span><span class="appbox-QRcode"><a href="javascript:void(0);" title="C&oacute;digo QR - Google Drive - armazenamento" onclick="javascript:abrirQR('https://chart.googleapis.com/chart?chs=400x400&cht=qr&chl=https%3A%2F%2Fapps.apple.com%2Fbr%2Fapp%2Fgoogle-drive-armazenamento%2Fid507874739&chld=L|0');return false;"><img alt="C&oacute;digo QR" src="https://macmagazine.com.br/wp-content/themes/newsblock-child/images/qr.png" /></a><a href="javascript:void(0);" title="C&oacute;digo QR - Google Drive - armazenamento" onclick="javascript:abrirQR('https://chart.googleapis.com/chart?chs=400x400&cht=qr&chl=https%3A%2F%2Fapps.apple.com%2Fbr%2Fapp%2Fgoogle-drive-armazenamento%2Fid507874739&chld=L|0');return false;">C&oacute;digo QR</a></span></div>
                </div><p><span class="credito">via <a href="https://www.androidpolice.com/google-drive-will-inform-you-when-your-file-violates-its-policies/">Android Police</a></span></p>
]]>
</content:encoded>
<wfw:commentRss>https://macmagazine.com.br/post/2021/12/15/google-drive-alertara-sobre-arquivos-marcados-como-spam/feed/</wfw:commentRss>
<slash:comments>0</slash:comments>
<post-id xmlns="com-wordpress:feed-additions:1">841480</post-id>
<media:content xmlns:media="http://search.yahoo.com/mrss/" medium="image" type="image/jpeg" url="https://macmagazine.com.br/wp-content/uploads/2020/10/06-Google-Workspace-1260x525.png" width="1200" height="500" />
</item>
</channel>
</rss>
"""

    var posts: Data? {
        return Data(example.utf8)
    }
}

struct MockPosts2 {

    let example = """
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0"
    xmlns:content="http://purl.org/rss/1.0/modules/content/"
    xmlns:wfw="http://wellformedweb.org/CommentAPI/"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:atom="http://www.w3.org/2005/Atom"
    xmlns:sy="http://purl.org/rss/1.0/modules/syndication/"
    xmlns:slash="http://purl.org/rss/1.0/modules/slash/"
    xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd"
xmlns:podcast="https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md"
xmlns:rawvoice="http://www.rawvoice.com/rawvoiceRssModule/"
xmlns:googleplay="http://www.google.com/schemas/play-podcasts/1.0"

    xmlns:georss="http://www.georss.org/georss"
    xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#"
    >
    <channel>
        <title>MacMagazine</title>
        <atom:link href="https://macmagazine.com.br/feed/?paged=0" rel="self" type="application/rss+xml" />
        <link>https://macmagazine.com.br</link>
        <description>O melhor pedaço da Maçã.</description>
        <lastBuildDate>Thu, 16 Dec 2021 15:04:05 +0000</lastBuildDate>
        <language>pt-BR</language>
        <sy:updatePeriod>
    hourly    </sy:updatePeriod>
        <sy:updateFrequency>
    1    </sy:updateFrequency>
        <generator>https://wordpress.org/?v=5.8.2</generator>
        <image>
            <url>https://macmagazine.com.br/wp-content/uploads/2018/02/mm-300x300.png</url>
            <title>MacMagazine</title>
            <link>https://macmagazine.com.br</link>
            <width>32</width>
            <height>32</height>
        </image>
        <!-- podcast_generator="Blubrry PowerPress/8.7.8" mode="advanced" feedslug="feed" Blubrry PowerPress Podcasting plugin for WordPress (https://www.blubrry.com/powerpress/) -->
        <atom:link rel="hub" href="https://pubsubhubbub.appspot.com/" />
        <itunes:summary>Blog sobre assuntos relacionados principalmente ao mundo Macintosh (Apple e afins), mas que também aborda tudo que vier à tona com relação a internet, tecnologia, novidades em informática, gadgets, eletrônicos etc. Inclusive pode falar sobre qualquer outra coisa, que não tem problema: basta que seja interessante. ;-)</itunes:summary>
        <itunes:author>MacMagazine.com.br</itunes:author>
        <itunes:explicit>clean</itunes:explicit>
        <itunes:image href="https://macmagazine.com.br/wp-content/uploads/powerpress/capa.png" />
        <itunes:type>episodic</itunes:type>
        <itunes:owner>
            <itunes:name>MacMagazine.com.br</itunes:name>
            <itunes:email>contato@macmagazine.com.br</itunes:email>
        </itunes:owner>
        <managingEditor>contato@macmagazine.com.br (MacMagazine.com.br)</managingEditor>
        <copyright>2002-2021 &#xA9; MacMagazine.com.br</copyright>
        <itunes:subtitle>Confira mais um episódio do podcast MacMagazine no Ar!</itunes:subtitle>
        <itunes:category text="News">
            <itunes:category text="Tech News" /></itunes:category>
        <googleplay:category text="News &amp; Politics"/>
        <rawvoice:rating>TV-14</rawvoice:rating>
        <rawvoice:location>Brasil</rawvoice:location>
        <podcast:location>Brasil</podcast:location>
        <rawvoice:frequency>Semanal</rawvoice:frequency>
        <rawvoice:subscribe feed="https://macmagazine.com.br/feed/?paged=0" itunes="https://podcasts.apple.com/br/podcast/macmagazine-no-ar/id547137017" spotify="https://open.spotify.com/show/52IrqJ0ZwPVp0kKXaOWnLP" deezer="https://www.deezer.com/br/show/13129"></rawvoice:subscribe>
        <site xmlns="com-wordpress:feed-additions:1">154826423</site>
        <item>
            <title>Pixelmator Photo chega ao iPhone</title>
            <link>https://macmagazine.com.br/post/2021/12/16/pixelmator-photo-chega-ao-iphone/</link>
            <comments>https://macmagazine.com.br/post/2021/12/16/pixelmator-photo-chega-ao-iphone/#respond</comments>
            <dc:creator>
                <![CDATA[Rafael Fischmann]]>
            </dc:creator>
            <pubDate>Thu, 16 Dec 2021 15:00:00 +0000</pubDate>
            <category>
                <![CDATA[Dicas]]>
            </category>
            <category>
                <![CDATA[Gadgets]]>
            </category>
            <category>
                <![CDATA[Software]]>
            </category>
            <category>
                <![CDATA[ajustes]]>
            </category>
            <category>
                <![CDATA[aplicativo]]>
            </category>
            <category>
                <![CDATA[app]]>
            </category>
            <category>
                <![CDATA[App Store]]>
            </category>
            <category>
                <![CDATA[aprendizado de máquina]]>
            </category>
            <category>
                <![CDATA[artefatos]]>
            </category>
            <category>
                <![CDATA[atualização]]>
            </category>
            <category>
                <![CDATA[cores]]>
            </category>
            <category>
                <![CDATA[crop]]>
            </category>
            <category>
                <![CDATA[denoise]]>
            </category>
            <category>
                <![CDATA[edição]]>
            </category>
            <category>
                <![CDATA[editor]]>
            </category>
            <category>
                <![CDATA[foto]]>
            </category>
            <category>
                <![CDATA[fotografia]]>
            </category>
            <category>
                <![CDATA[fotos]]>
            </category>
            <category>
                <![CDATA[imagem]]>
            </category>
            <category>
                <![CDATA[imagens]]>
            </category>
            <category>
                <![CDATA[iPhone]]>
            </category>
            <category>
                <![CDATA[machine learning]]>
            </category>
            <category>
                <![CDATA[não-destrutiva]]>
            </category>
            <category>
                <![CDATA[Pixelmator]]>
            </category>
            <category>
                <![CDATA[Pixelmator Photo]]>
            </category>
            <category>
                <![CDATA[ruídos]]>
            </category>
            <category>
                <![CDATA[update]]>
            </category>
            <guid isPermaLink="false">https://macmagazine.com.br/?p=841702</guid>
            <description>
                <![CDATA[Lançado originalmente em abril de 2019 para iPad, o Pixelmator Photo acaba de chegar hoje à sua versão&#8230;]]>
            </description>
            <content:encoded>
                <![CDATA[<img width="1024" height="1024" src="https://macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-Icon.png" class="webfeedsFeaturedVisual wp-post-image" alt="" style="display: block; margin: auto; margin-bottom: 5px;max-width: 100%;" link_thumbnail="" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-Icon.png 1024w, https://macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-Icon-600x600.png 600w, https://macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-Icon-300x300.png 300w, https://macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-Icon-80x80.png 80w, https://macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-Icon-110x110.png 110w, https://macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-Icon-380x380.png 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-Icon-800x800.png 800w" sizes="(max-width: 1024px) 100vw, 1024px" /><p><a href="https://macmagazine.com.br/post/2019/04/09/saiu-o-pixelmator-photo-avancado-editor-de-fotos-para-ipad/">Lançado originalmente em abril de 2019</a> para iPad, o<strong>Pixelmator Photo</strong> acaba de chegar hoje à sua versão 2.0 e agora roda também em iPhones.<img src="https://s.w.org/images/core/emoji/13.1.0/72x72/1f38a.png" alt="🎊" class="wp-smiley" style="height: 1em; max-height: 1em;" /></p><p>Eu, que não tenho mais iPad há alguns anos, esperava por isso há bastante tempo. Tenho um ou outro editor de fotos no meu iPhone, mas sempre sonhei com o Pixelmator — afinal, também uso hoje em dia o <a href="https://macmagazine.com.br/sobre/pixelmator-pro/">Pixelmator Pro</a> como meu editor primário no Mac.</p><div class="wp-block-jetpack-tiled-gallery aligncenter is-style-rectangular"><div class="tiled-gallery__gallery"><div class="tiled-gallery__row"><div class="tiled-gallery__col" style="flex-basis:19.76240%"><figure class="tiled-gallery__item"><a href="https://i2.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-1-%E2%80%93-Lead-Image-623x1260.png?ssl=1"><img srcset="https://i2.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-1-%E2%80%93-Lead-Image-623x1260.png?strip=info&#038;w=600&#038;ssl=1 600w,https://i2.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-1-%E2%80%93-Lead-Image-623x1260.png?strip=info&#038;w=900&#038;ssl=1 900w,https://i2.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-1-%E2%80%93-Lead-Image-623x1260.png?strip=info&#038;w=1200&#038;ssl=1 1200w,https://i2.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-1-%E2%80%93-Lead-Image-623x1260.png?strip=info&#038;w=1315&#038;ssl=1 1315w" alt="" data-height="2659" data-id="841707" data-link="https://macmagazine.com.br/?attachment_id=841707" data-url="https://macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-–-1-–-Lead-Image-623x1260.png" data-width="1315" src="https://i2.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-1-%E2%80%93-Lead-Image-623x1260.png?ssl=1" data-amp-layout="responsive"/></a></figure></div><div class="tiled-gallery__col" style="flex-basis:80.23760%"><figure class="tiled-gallery__item"><a href="https://i0.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-5-%E2%80%93-Landscape-Editing-1260x623.png?ssl=1"><img srcset="https://i0.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-5-%E2%80%93-Landscape-Editing-1260x623.png?strip=info&#038;w=600&#038;ssl=1 600w,https://i0.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-5-%E2%80%93-Landscape-Editing-1260x623.png?strip=info&#038;w=900&#038;ssl=1 900w,https://i0.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-5-%E2%80%93-Landscape-Editing-1260x623.png?strip=info&#038;w=1200&#038;ssl=1 1200w,https://i0.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-5-%E2%80%93-Landscape-Editing-1260x623.png?strip=info&#038;w=1500&#038;ssl=1 1500w,https://i0.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-5-%E2%80%93-Landscape-Editing-1260x623.png?strip=info&#038;w=1800&#038;ssl=1 1800w,https://i0.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-5-%E2%80%93-Landscape-Editing-1260x623.png?strip=info&#038;w=2000&#038;ssl=1 2000w" alt="" data-height="1315" data-id="841713" data-link="https://macmagazine.com.br/?attachment_id=841713" data-url="https://macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-–-5-–-Landscape-Editing-1260x623.png" data-width="2659" src="https://i0.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-5-%E2%80%93-Landscape-Editing-1260x623.png?ssl=1" data-amp-layout="responsive"/></a></figure></div></div><div class="tiled-gallery__row"><div class="tiled-gallery__col" style="flex-basis:25.00000%"><figure class="tiled-gallery__item"><a href="https://i1.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-2-%E2%80%93-Machine-Learning-623x1260.png?ssl=1"><img srcset="https://i1.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-2-%E2%80%93-Machine-Learning-623x1260.png?strip=info&#038;w=600&#038;ssl=1 600w,https://i1.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-2-%E2%80%93-Machine-Learning-623x1260.png?strip=info&#038;w=900&#038;ssl=1 900w,https://i1.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-2-%E2%80%93-Machine-Learning-623x1260.png?strip=info&#038;w=1200&#038;ssl=1 1200w,https://i1.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-2-%E2%80%93-Machine-Learning-623x1260.png?strip=info&#038;w=1315&#038;ssl=1 1315w" alt="" data-height="2659" data-id="841709" data-link="https://macmagazine.com.br/?attachment_id=841709" data-url="https://macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-–-2-–-Machine-Learning-623x1260.png" data-width="1315" src="https://i1.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-2-%E2%80%93-Machine-Learning-623x1260.png?ssl=1" data-amp-layout="responsive"/></a></figure></div><div class="tiled-gallery__col" style="flex-basis:25.00000%"><figure class="tiled-gallery__item"><a href="https://i2.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-3-%E2%80%93-Filmstrip-623x1260.png?ssl=1"><img srcset="https://i2.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-3-%E2%80%93-Filmstrip-623x1260.png?strip=info&#038;w=600&#038;ssl=1 600w,https://i2.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-3-%E2%80%93-Filmstrip-623x1260.png?strip=info&#038;w=900&#038;ssl=1 900w,https://i2.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-3-%E2%80%93-Filmstrip-623x1260.png?strip=info&#038;w=1200&#038;ssl=1 1200w,https://i2.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-3-%E2%80%93-Filmstrip-623x1260.png?strip=info&#038;w=1315&#038;ssl=1 1315w" alt="" data-height="2659" data-id="841710" data-link="https://macmagazine.com.br/?attachment_id=841710" data-url="https://macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-–-3-–-Filmstrip-623x1260.png" data-width="1315" src="https://i2.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-3-%E2%80%93-Filmstrip-623x1260.png?ssl=1" data-amp-layout="responsive"/></a></figure></div><div class="tiled-gallery__col" style="flex-basis:25.00000%"><figure class="tiled-gallery__item"><a href="https://i1.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-4-%E2%80%93-Browser-623x1260.png?ssl=1"><img srcset="https://i1.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-4-%E2%80%93-Browser-623x1260.png?strip=info&#038;w=600&#038;ssl=1 600w,https://i1.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-4-%E2%80%93-Browser-623x1260.png?strip=info&#038;w=900&#038;ssl=1 900w,https://i1.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-4-%E2%80%93-Browser-623x1260.png?strip=info&#038;w=1200&#038;ssl=1 1200w,https://i1.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-4-%E2%80%93-Browser-623x1260.png?strip=info&#038;w=1315&#038;ssl=1 1315w" alt="" data-height="2659" data-id="841712" data-link="https://macmagazine.com.br/?attachment_id=841712" data-url="https://macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-–-4-–-Browser-623x1260.png" data-width="1315" src="https://i1.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-4-%E2%80%93-Browser-623x1260.png?ssl=1" data-amp-layout="responsive"/></a></figure></div><div class="tiled-gallery__col" style="flex-basis:25.00000%"><figure class="tiled-gallery__item"><a href="https://i0.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-6-%E2%80%93-Crop-Tool-623x1260.png?ssl=1"><img srcset="https://i0.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-6-%E2%80%93-Crop-Tool-623x1260.png?strip=info&#038;w=600&#038;ssl=1 600w,https://i0.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-6-%E2%80%93-Crop-Tool-623x1260.png?strip=info&#038;w=900&#038;ssl=1 900w,https://i0.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-6-%E2%80%93-Crop-Tool-623x1260.png?strip=info&#038;w=1200&#038;ssl=1 1200w,https://i0.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-6-%E2%80%93-Crop-Tool-623x1260.png?strip=info&#038;w=1315&#038;ssl=1 1315w" alt="" data-height="2659" data-id="841714" data-link="https://macmagazine.com.br/?attachment_id=841714" data-url="https://macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-–-6-–-Crop-Tool-623x1260.png" data-width="1315" src="https://i0.wp.com/macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-%E2%80%93-6-%E2%80%93-Crop-Tool-623x1260.png?ssl=1" data-amp-layout="responsive"/></a></figure></div></div></div></div><p>O Pixelmator Photo para iPhone traz toda a experiência de edição conhecida do Pixelmator para as telinhas (nem tanto, vai… mas comparadas com as de iPads e Macs até vai <img src="https://s.w.org/images/core/emoji/13.1.0/72x72/1f61c.png" alt="😜" class="wp-smiley" style="height: 1em; max-height: 1em;" />) dos smartphones, adicionando um browser redesenhado para fotos e a possibilidade de remover ruídos/artefatos por meio de aprendizado de máquina.</p><p>Todos os ajustes feitos pelo Pixelmator Photo são não-destrutivos, incluindo a remoção de objetos com uma simples seleção com os dedos. Ele também inclui os já conhecidos algoritmos de ML do Pixelmator para aprimorar imagens automaticamente, <a href="https://macmagazine.com.br/post/2020/09/15/pixelmator-photo-para-ipad-ganha-recurso-ml-super-resolution/">aumentar resolução</a>, etc. E já é compatível com mais de 600 formatos de imagens RAW,<a href="https://macmagazine.com.br/post/2020/12/10/pixelmator-photo-agora-suporta-proraw-dos-iphones-12-pro/">incluindo o Apple ProRAW</a>.</p><p>Por tempo limitado, em promoção de lançamento, o Pixelmator Photo <a href="https://apps.apple.com/br/app/pixelmator-photo/id1444636541">está com <strong>50% de desconto na App Store</strong></a>. Essa versão para iPhone é uma atualização do app já existente, ou seja, ele está se tornando universal; quem já o tinha no iPad pode, agora, instalá-lo em seus iPhones sem pagar nada mais por isso.</p><hr /><div class="appbox"><div class="appbox-icon"><a href="https://apps.apple.com/br/app/pixelmator-photo/id1444636541" target="_blank"><img class="appbox-iconiOS" alt="&Iacute;cone do app Pixelmator Photo" src="https://is2-ssl.mzstatic.com/image/thumb/Purple116/v4/9d/86/24/9d862475-719d-75d5-2fee-4a4091416bcf/AppIcon-0-1x_U007emarketing-0-7-0-sRGB-85-220.png/256x256bb.png" /></a></div><div class="appbox-details"><span class="appbox-name"><a href="https://apps.apple.com/br/app/pixelmator-photo/id1444636541" target="_blank">Pixelmator Photo</a></span><span class="appbox-de">de <strong><a href="https://www.pixelmator.com/photo/" target="_blank" class="no_icon" rel="nofollow">Pixelmator Team</a></strong></span><div class="appbox-devices"><img src="https://macmagazine.com.br/wp-content/uploads/2015/11/devices_ipad.png" alt="Compat&iacute;vel com iPads" title="Compat&iacute;vel com iPads" class="appbox-devicesiPad" /><img src="https://macmagazine.com.br/wp-content/uploads/2015/11/devices_iphone.png" alt="Compat&iacute;vel com iPhones" title="Compat&iacute;vel com iPhones" class="appbox-devicesiPhone" /></div><div class="appbox-info">Vers&atilde;o <strong>2.0</strong> (193.5 MB)<br />
                    Requer o <strong>iOS 14.0</strong> ou superior</div></div><div class="appbox-badge"><span class="appbox-price">R$ 22,90 <b class="appbox-oldprice">R$ 44.90</b></span><span><a href="https://apps.apple.com/br/app/pixelmator-photo/id1444636541" target="_blank"><img alt="Badge - Baixar na App Store" src="https://macmagazine.com.br/wp-content/uploads/2017/11/22-badge_appstore.png" class="badgeInvert" /></a></span><span class="appbox-QRcode"><a href="javascript:void(0);" title="C&oacute;digo QR - Pixelmator Photo" onclick="javascript:abrirQR('https://chart.googleapis.com/chart?chs=400x400&cht=qr&chl=https%3A%2F%2Fapps.apple.com%2Fbr%2Fapp%2Fpixelmator-photo%2Fid1444636541&chld=L|0');return false;"><img alt="C&oacute;digo QR" src="https://macmagazine.com.br/wp-content/themes/newsblock-child/images/qr.png" /></a><a href="javascript:void(0);" title="C&oacute;digo QR - Pixelmator Photo" onclick="javascript:abrirQR('https://chart.googleapis.com/chart?chs=400x400&cht=qr&chl=https%3A%2F%2Fapps.apple.com%2Fbr%2Fapp%2Fpixelmator-photo%2Fid1444636541&chld=L|0');return false;">C&oacute;digo QR</a></span></div>
                </div>
]]>
</content:encoded>
<wfw:commentRss>https://macmagazine.com.br/post/2021/12/16/pixelmator-photo-chega-ao-iphone/feed/</wfw:commentRss>
<slash:comments>0</slash:comments>
<post-id xmlns="com-wordpress:feed-additions:1">841702</post-id>
<media:content xmlns:media="http://search.yahoo.com/mrss/" medium="image" type="image/jpeg" url="https://macmagazine.com.br/wp-content/uploads/2021/12/Pixelmator-Photo-Icon.png" width="1024" height="1024" />
</item>
<item>
    <title>Vídeo: caixa de HomePod é, na verdade, uma… bomba de glitter!</title>
    <link>https://macmagazine.com.br/post/2021/12/16/video-caixa-de-homepod-e-na-verdade-uma-bomba-de-glitter/</link>
    <comments>https://macmagazine.com.br/post/2021/12/16/video-caixa-de-homepod-e-na-verdade-uma-bomba-de-glitter/#respond</comments>
    <dc:creator>
        <![CDATA[Bruno Santana]]>
    </dc:creator>
    <pubDate>Thu, 16 Dec 2021 13:30:00 +0000</pubDate>
    <category>
        <![CDATA[Humor]]>
    </category>
    <category>
        <![CDATA[Off-Topic]]>
    </category>
    <category>
        <![CDATA[Vídeos]]>
    </category>
    <category>
        <![CDATA[bomba]]>
    </category>
    <category>
        <![CDATA[Caixa]]>
    </category>
    <category>
        <![CDATA[engenharia]]>
    </category>
    <category>
        <![CDATA[glitter]]>
    </category>
    <category>
        <![CDATA[HomePod]]>
    </category>
    <category>
        <![CDATA[Jony Ive]]>
    </category>
    <category>
        <![CDATA[ladrão]]>
    </category>
    <category>
        <![CDATA[ladrões]]>
    </category>
    <category>
        <![CDATA[Mark Rober]]>
    </category>
    <category>
        <![CDATA[peça]]>
    </category>
    <category>
        <![CDATA[vídeo]]>
    </category>
    <guid isPermaLink="false">https://macmagazine.com.br/?p=841720</guid>
    <description>
        <![CDATA[Talvez o nome Mark Rober não desperte nenhuma lembrança na sua cabeça, mas você possivelmente já ouviu falar&#8230;]]>
    </description>
    <content:encoded>
        <![CDATA[<img width="1200" height="675" src="https://macmagazine.com.br/wp-content/uploads/2021/12/16-glitter-homepod-1260x709.jpg" class="webfeedsFeaturedVisual wp-post-image" alt="Bomba de glitter em caixa de HomePod, por Mark Rober" style="display: block; margin: auto; margin-bottom: 5px;max-width: 100%;" link_thumbnail="" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/16-glitter-homepod-1260x709.jpg 1260w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-glitter-homepod-600x338.jpg 600w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-glitter-homepod-300x169.jpg 300w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-glitter-homepod-380x214.jpg 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-glitter-homepod-800x450.jpg 800w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-glitter-homepod-1160x653.jpg 1160w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-glitter-homepod.jpg 1280w" sizes="(max-width: 1200px) 100vw, 1200px" /><p>Talvez o nome <strong>Mark Rober</strong> não desperte nenhuma lembrança na sua cabeça, mas você possivelmente já ouviu falar dos seus &#8220;feitos&#8221; natalinos: pelos últimos quatro anos, o<em>YouTuber</em> — e ex-engenheiro da NASA, que<a href="https://macmagazine.com.br/post/2018/06/27/youtuber-esta-trabalhando-em-projeto-de-vr-para-o-sistema-de-carros-autonomos-da-apple/">já trabalhou inclusive com a Apple </a>— empreendeu esforços cada vez maiores para construir<strong>&#8220;bombas de glitter&#8221;</strong> dentro de caixas — tudo para pregar uma bela duma peça em ladrões que roubam pacotes deixados nas portas das casas dos seus donos.</p><p>Pois em 2021, Rober superou todas as tentativas anteriores: a &#8220;Bomba de Glitter 4.0&#8221; tem quatro smartphones para filmar a reação dos bandidos de qualquer ângulo, um sistema pneumático que faz a tampa da caixa saltar para fora no momento do clímax, uma buzina embutida para assustar ainda mais a pessoa, um microfone para gravar todos os acontecimentos e muito mais.</p><p>O melhor: todo esse pacote foi colocado dentro de uma caixa (falsa) de <strong>HomePod</strong> — com direito a um clipe introdutório no maior estilo Apple/Jony Ive, como vocês podem ver a partir dos 4:40 no vídeo abaixo.</p><figure class="wp-block-embed aligncenter is-type-video is-provider-youtube wp-block-embed-youtube wp-embed-aspect-16-9 wp-has-aspect-ratio"><div class="wp-block-embed__wrapper"><iframe loading="lazy" title="EXPLODING Glitter Bomb 4.0 vs. Package Thieves" width="1200" height="675" src="https://www.youtube.com/embed/3c584TGG7jQ?feature=oembed" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div></figure><p>Quem lê o <strong><em>MacMagazine</em></strong> há algum tempo possivelmente se lembrará que esta não é a primeira vez do HomePod nas pegadinhas de Rober: ele já fez uma das suas bombas de glitter disfarçadas dentro de uma caixa do finado alto-falante, <a href="https://macmagazine.com.br/post/2018/12/18/youtuber-usa-homepod-como-isca-para-aplicar-pegadinha-em-ladroes/">como comentamos por aqui em 2018</a>. A versão de 2021, entretanto, é<em>muito</em> mais avançada.</p><p>Vale conferir também um vídeo de <em>making of </em>publicado no canal do estúdio Bubba&#8217;s LA, que mostra como foram realizados os efeitos do vídeo principal — efeitos práticos, vale notar, com intervenção mínima do computador.</p><figure class="wp-block-embed aligncenter is-type-video is-provider-youtube wp-block-embed-youtube wp-embed-aspect-16-9 wp-has-aspect-ratio"><div class="wp-block-embed__wrapper"><iframe loading="lazy" title="Mark Rober Glitterbomb 4.0 vs. Porch Pirates BTS" width="1200" height="675" src="https://www.youtube.com/embed/ZIdh7hxz1G8?feature=oembed" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div></figure><p>Muito divertido — exceto, claro, para os espertinhos que ficarão com glitter em todos os centímetros quadrados dos seus corpos até o Natal que vem… <img src="https://s.w.org/images/core/emoji/13.1.0/72x72/1f61c.png" alt="😜" class="wp-smiley" style="height: 1em; max-height: 1em;" /></p><p><span class="credito">via <a href="https://www.techspot.com/news/92634-glitter-bomb-40-makes-porch-pirates-pay.html">TechSpot</a></span></p>
]]>
</content:encoded>
<wfw:commentRss>https://macmagazine.com.br/post/2021/12/16/video-caixa-de-homepod-e-na-verdade-uma-bomba-de-glitter/feed/</wfw:commentRss>
<slash:comments>0</slash:comments>
<post-id xmlns="com-wordpress:feed-additions:1">841720</post-id>
<media:content xmlns:media="http://search.yahoo.com/mrss/" medium="image" type="image/jpeg" url="https://macmagazine.com.br/wp-content/uploads/2021/12/16-glitter-homepod-1260x709.jpg" width="1200" height="675" />
</item>
<item>
    <title>Logitech lança no Brasil linha POP com periféricos e acessórios</title>
    <link>https://macmagazine.com.br/post/2021/12/16/logitech-lanca-no-brasil-linha-pop-com-perifericos-e-acessorios/</link>
    <comments>https://macmagazine.com.br/post/2021/12/16/logitech-lanca-no-brasil-linha-pop-com-perifericos-e-acessorios/#respond</comments>
    <dc:creator>
        <![CDATA[Luiz Gustavo Ribeiro]]>
    </dc:creator>
    <pubDate>Thu, 16 Dec 2021 13:10:00 +0000</pubDate>
    <category>
        <![CDATA[Acessórios]]>
    </category>
    <category>
        <![CDATA[Design]]>
    </category>
    <category>
        <![CDATA[Bluetooth]]>
    </category>
    <category>
        <![CDATA[Brasil]]>
    </category>
    <category>
        <![CDATA[cores]]>
    </category>
    <category>
        <![CDATA[Desk Mat]]>
    </category>
    <category>
        <![CDATA[emoji]]>
    </category>
    <category>
        <![CDATA[lançamento]]>
    </category>
    <category>
        <![CDATA[linha POP]]>
    </category>
    <category>
        <![CDATA[Logitech]]>
    </category>
    <category>
        <![CDATA[Mouse]]>
    </category>
    <category>
        <![CDATA[Mouse Pad]]>
    </category>
    <category>
        <![CDATA[periféricos]]>
    </category>
    <category>
        <![CDATA[Pop Keys]]>
    </category>
    <category>
        <![CDATA[POP Mouse]]>
    </category>
    <category>
        <![CDATA[preço]]>
    </category>
    <category>
        <![CDATA[sem fio]]>
    </category>
    <category>
        <![CDATA[teclado mecânico]]>
    </category>
    <guid isPermaLink="false">https://macmagazine.com.br/?p=841717</guid>
    <description>
        <![CDATA[No mês passado, a Logitech anunciou uma nova linha de periféricos que foge um pouco dos tons sóbrios&#8230;]]>
    </description>
    <content:encoded>
        <![CDATA[<img width="1200" height="675" src="https://macmagazine.com.br/wp-content/uploads/2021/12/16-Logitech-POP-1260x709.jpg" class="webfeedsFeaturedVisual wp-post-image" alt="Logitech POP" style="display: block; margin: auto; margin-bottom: 5px;max-width: 100%;" link_thumbnail="" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/16-Logitech-POP-1260x709.jpg 1260w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-Logitech-POP-600x338.jpg 600w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-Logitech-POP-300x169.jpg 300w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-Logitech-POP-380x214.jpg 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-Logitech-POP-800x450.jpg 800w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-Logitech-POP-1160x653.jpg 1160w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-Logitech-POP.jpg 1280w" sizes="(max-width: 1200px) 100vw, 1200px" /><p>No mês passado, a <strong>Logitech</strong><a href="https://macmagazine.com.br/post/2021/11/10/logitech-lanca-mouse-teclado-coloridos-com-foco-em-emojis/">anunciou uma nova linha de periféricos</a> que foge um pouco dos tons sóbrios e monocromáticos. Falo da<strong>linha POP</strong>, que estreou com teclados e mouse coloridíssimos da nova série<em>Vibrant Studio</em> — a qual está agora disponível no<strong>Brasil</strong>.</p><p>Como havíamos informado, a linha é composta pelo <strong><a href="https://www.logitech.com/pt-br/products/mice/pop-wireless-mouse.910-006550.html">POP Mouse</a></strong> e pelo <strong><a href="https://www.logitech.com/pt-br/products/keyboards/pop-keys-wireless-mechanical.920-010711.html">POP Keys</a></strong>, os quais são sem fio e apresentam a <strong>função emoji</strong> — a qual permite acessar facilmente o painel de emojis, definir uma opção padrão e personalizar teclas/ações.</p><figure class="wp-block-gallery aligncenter columns-3 is-cropped"><ul class="blocks-gallery-grid"><li class="blocks-gallery-item"><figure><a href="https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-3.jpg"><img width="1260" height="708" src="https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-3-1260x708.jpg" alt="Acessórios POP (mouse e teclado) da Logitech" data-id="832897" data-full-url="https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-3.jpg" data-link="https://macmagazine.com.br/post/2021/11/10/logitech-lanca-mouse-teclado-coloridos-com-foco-em-emojis/09-logitech-pop-mouse-teclado-3/" class="wp-image-832897" srcset="https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-3-1260x708.jpg 1260w, https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-3-600x337.jpg 600w, https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-3-300x169.jpg 300w, https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-3-1536x863.jpg 1536w, https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-3-380x214.jpg 380w, https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-3-800x450.jpg 800w, https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-3-1160x652.jpg 1160w, https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-3.jpg 1594w" sizes="(max-width: 1260px) 100vw, 1260px" /></a></figure></li><li class="blocks-gallery-item"><figure><a href="https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-2.jpg"><img width="1260" height="708" src="https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-2-1260x708.jpg" alt="Acessórios POP (mouse e teclado) da Logitech" data-id="832896" data-full-url="https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-2.jpg" data-link="https://macmagazine.com.br/post/2021/11/10/logitech-lanca-mouse-teclado-coloridos-com-foco-em-emojis/09-logitech-pop-mouse-teclado-2/" class="wp-image-832896" srcset="https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-2-1260x708.jpg 1260w, https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-2-600x337.jpg 600w, https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-2-300x169.jpg 300w, https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-2-1536x863.jpg 1536w, https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-2-380x214.jpg 380w, https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-2-800x450.jpg 800w, https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-2-1160x652.jpg 1160w, https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-2.jpg 1594w" sizes="(max-width: 1260px) 100vw, 1260px" /></a></figure></li><li class="blocks-gallery-item"><figure><a href="https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado.jpg"><img width="1260" height="708" src="https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-1260x708.jpg" alt="Acessórios POP (mouse e teclado) da Logitech" data-id="832895" data-full-url="https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado.jpg" data-link="https://macmagazine.com.br/post/2021/11/10/logitech-lanca-mouse-teclado-coloridos-com-foco-em-emojis/09-logitech-pop-mouse-teclado/" class="wp-image-832895" srcset="https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-1260x708.jpg 1260w, https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-600x337.jpg 600w, https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-300x169.jpg 300w, https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-1536x863.jpg 1536w, https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-380x214.jpg 380w, https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-800x450.jpg 800w, https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado-1160x652.jpg 1160w, https://macmagazine.com.br/wp-content/uploads/2021/11/09-logitech-pop-mouse-teclado.jpg 1594w" sizes="(max-width: 1260px) 100vw, 1260px" /></a></figure></li></ul></figure><p>Tanto o teclado quanto o mouse POP podem se conectar a até três dispositivos ao mesmo tempo por meio de Bluetooth ou do receptor sem fio Logi Bolt. Cada um também vem com a garantia de durabilidade e bateria de longa duração.</p><p>O teclado mecânico <a href="https://www.logitech.com/pt-br/products/keyboards/pop-keys-wireless-mechanical.920-010713.html">POP Keys</a> e o<a href="https://www.logitech.com/pt-br/products/mice/pop-wireless-mouse.910-006550.html">POP Mouse</a> já estão disponíveis pelos preços sugeridos de<strong>R$800</strong> e<strong>R$180</strong>, respectivamente.</p><h2>Acessórios</h2><p>A Logitech também também lançou seus novos <a href="https://www.logitech.com/pt-br/products/mice/mouse-pad-studio-series.956-000035.html"><strong>Mouse Pad</strong></a> e <a href="https://www.logitech.com/pt-br/products/mice/desk-mat-studio-series.956-000048.html"><strong>Desk Mat</strong></a> para compor os periféricos da linha POP. Além de coloridos, eles são macios, suaves e antiderrapantes. Segundo a fabricante, a superfície lisa, confortável e de trama fina proporciona um deslizamento silencioso e sem esforço para o mouse.&nbsp;</p><figure class="wp-block-gallery aligncenter columns-2 is-cropped"><ul class="blocks-gallery-grid"><li class="blocks-gallery-item"><figure><a href="https://macmagazine.com.br/wp-content/uploads/2021/12/16-logi-mouse-pad.png"><img width="1260" height="709" src="https://macmagazine.com.br/wp-content/uploads/2021/12/16-logi-mouse-pad-1260x709.png" alt="Mouse Pad da Logitech" data-id="841723" data-full-url="https://macmagazine.com.br/wp-content/uploads/2021/12/16-logi-mouse-pad.png" data-link="https://macmagazine.com.br/?attachment_id=841723" class="wp-image-841723" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/16-logi-mouse-pad-1260x709.png 1260w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-logi-mouse-pad-600x337.png 600w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-logi-mouse-pad-300x169.png 300w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-logi-mouse-pad-1536x864.png 1536w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-logi-mouse-pad-380x214.png 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-logi-mouse-pad-800x450.png 800w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-logi-mouse-pad-1160x652.png 1160w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-logi-mouse-pad.png 1860w" sizes="(max-width: 1260px) 100vw, 1260px" /></a></figure></li><li class="blocks-gallery-item"><figure><a href="https://macmagazine.com.br/wp-content/uploads/2021/12/16-logi-desk-mat.png"><img width="1260" height="709" src="https://macmagazine.com.br/wp-content/uploads/2021/12/16-logi-desk-mat-1260x709.png" alt="Desk Mat da Logitech" data-id="841722" data-full-url="https://macmagazine.com.br/wp-content/uploads/2021/12/16-logi-desk-mat.png" data-link="https://macmagazine.com.br/?attachment_id=841722" class="wp-image-841722" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/16-logi-desk-mat-1260x709.png 1260w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-logi-desk-mat-600x337.png 600w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-logi-desk-mat-300x169.png 300w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-logi-desk-mat-1536x864.png 1536w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-logi-desk-mat-380x214.png 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-logi-desk-mat-800x450.png 800w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-logi-desk-mat-1160x652.png 1160w, https://macmagazine.com.br/wp-content/uploads/2021/12/16-logi-desk-mat.png 1860w" sizes="(max-width: 1260px) 100vw, 1260px" /></a></figure></li></ul></figure><p>Ambos os acessórios estão disponíveis no Brasil pelos preços sugeridos de<strong> R$60</strong> (Mouse Pad) e<strong>R$140</strong> (Desk Mat).</p>
]]>
</content:encoded>
<wfw:commentRss>https://macmagazine.com.br/post/2021/12/16/logitech-lanca-no-brasil-linha-pop-com-perifericos-e-acessorios/feed/</wfw:commentRss>
<slash:comments>0</slash:comments>
<post-id xmlns="com-wordpress:feed-additions:1">841717</post-id>
<media:content xmlns:media="http://search.yahoo.com/mrss/" medium="image" type="image/jpeg" url="https://macmagazine.com.br/wp-content/uploads/2021/12/16-Logitech-POP-1260x709.jpg" width="1200" height="675" />
</item>
<item>
    <title>★ Um iPhone seminovo pode ser aquele superpresente!</title>
    <link>https://macmagazine.com.br/post/2021/12/16/um-iphone-seminovo-pode-ser-aquele-superpresente/</link>
    <comments>https://macmagazine.com.br/post/2021/12/16/um-iphone-seminovo-pode-ser-aquele-superpresente/#respond</comments>
    <dc:creator>
        <![CDATA[Informe Publicitário]]>
    </dc:creator>
    <pubDate>Thu, 16 Dec 2021 13:00:00 +0000</pubDate>
    <category>
        <![CDATA[Apple]]>
    </category>
    <category>
        <![CDATA[Destaques]]>
    </category>
    <category>
        <![CDATA[Dicas]]>
    </category>
    <category>
        <![CDATA[Dinheiro]]>
    </category>
    <category>
        <![CDATA[Publieditorial]]>
    </category>
    <category>
        <![CDATA[Telefonia]]>
    </category>
    <category>
        <![CDATA[aparelho]]>
    </category>
    <category>
        <![CDATA[assistência]]>
    </category>
    <category>
        <![CDATA[assistência técnica]]>
    </category>
    <category>
        <![CDATA[assistência técnica especializada]]>
    </category>
    <category>
        <![CDATA[Brasília]]>
    </category>
    <category>
        <![CDATA[campinas]]>
    </category>
    <category>
        <![CDATA[compra]]>
    </category>
    <category>
        <![CDATA[compras]]>
    </category>
    <category>
        <![CDATA[cupom]]>
    </category>
    <category>
        <![CDATA[desconto]]>
    </category>
    <category>
        <![CDATA[device]]>
    </category>
    <category>
        <![CDATA[dispositivo]]>
    </category>
    <category>
        <![CDATA[garantia]]>
    </category>
    <category>
        <![CDATA[iCaiu]]>
    </category>
    <category>
        <![CDATA[iCaiu Store]]>
    </category>
    <category>
        <![CDATA[iPhone]]>
    </category>
    <category>
        <![CDATA[iPhone 11]]>
    </category>
    <category>
        <![CDATA[iPhone 12 Pro Max]]>
    </category>
    <category>
        <![CDATA[iPhone 7]]>
    </category>
    <category>
        <![CDATA[iPhone XR]]>
    </category>
    <category>
        <![CDATA[loja]]>
    </category>
    <category>
        <![CDATA[oferta]]>
    </category>
    <category>
        <![CDATA[Prêmio Reclame Aqui]]>
    </category>
    <category>
        <![CDATA[reparo]]>
    </category>
    <category>
        <![CDATA[Rio de Janeiro]]>
    </category>
    <category>
        <![CDATA[São Paulo]]>
    </category>
    <category>
        <![CDATA[seminovo]]>
    </category>
    <category>
        <![CDATA[seminovos]]>
    </category>
    <category>
        <![CDATA[tela]]>
    </category>
    <category>
        <![CDATA[usado]]>
    </category>
    <category>
        <![CDATA[usados]]>
    </category>
    <category>
        <![CDATA[venda]]>
    </category>
    <category>
        <![CDATA[vendas]]>
    </category>
    <guid isPermaLink="false">https://macmagazine.com.br/?p=841639</guid>
    <description>
        <![CDATA[Com a alta do dólar e a inflação acima de dois dígitos, comprar um iPhone novo se tornou&#8230;]]>
    </description>
    <content:encoded>
        <![CDATA[<img width="1200" height="800" src="https://macmagazine.com.br/wp-content/uploads/2021/12/sabri-tuzcu-rYnQwRsNpE0-unsplash-1260x840.jpg" class="webfeedsFeaturedVisual wp-post-image" alt="" style="display: block; margin: auto; margin-bottom: 5px;max-width: 100%;" link_thumbnail="" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/sabri-tuzcu-rYnQwRsNpE0-unsplash-1260x840.jpg 1260w, https://macmagazine.com.br/wp-content/uploads/2021/12/sabri-tuzcu-rYnQwRsNpE0-unsplash-600x400.jpg 600w, https://macmagazine.com.br/wp-content/uploads/2021/12/sabri-tuzcu-rYnQwRsNpE0-unsplash-300x200.jpg 300w, https://macmagazine.com.br/wp-content/uploads/2021/12/sabri-tuzcu-rYnQwRsNpE0-unsplash-1536x1024.jpg 1536w, https://macmagazine.com.br/wp-content/uploads/2021/12/sabri-tuzcu-rYnQwRsNpE0-unsplash-2048x1365.jpg 2048w, https://macmagazine.com.br/wp-content/uploads/2021/12/sabri-tuzcu-rYnQwRsNpE0-unsplash-380x253.jpg 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/sabri-tuzcu-rYnQwRsNpE0-unsplash-800x533.jpg 800w, https://macmagazine.com.br/wp-content/uploads/2021/12/sabri-tuzcu-rYnQwRsNpE0-unsplash-1160x773.jpg 1160w" sizes="(max-width: 1200px) 100vw, 1200px" /><p>Com a alta do dólar e a inflação acima de dois dígitos, comprar um iPhone novo se tornou algo difícil de ser alcançado por nós, meros mortais. Tendo <a href="https://macmagazine.com.br/post/2021/09/15/quantos-dias-preciso-trabalhar-para-comprar-um-iphone-13-pro/">os iPhones mais caros do mundo</a>, para nós,<em>Applemaníacos</em>, estar sempre com as mais recentes novidades da empresa não é tarefa fácil.</p><p>Mas não perca as suas esperanças, ainda, pois a dica que damos a você é a de investir nos aparelhos seminovos, os queridinhos dos brasileiros nesses anos de vacas magras. E para quem está vendo este artigo antes do dia 22 de dezembro, saiba que você poderá aproveitar <strong>um desconto especial na iCaiu Store</strong> para os leitores do<em><strong>MacMagazine</strong></em>, no fim deste post! <img src="https://s.w.org/images/core/emoji/13.1.0/72x72/1f603.png" alt="😃" class="wp-smiley" style="height: 1em; max-height: 1em;" /></p><p>No Brasil, entre os dez aparelhos seminovos mais comprados, seis deles são iPhones — com o já &#8220;velhinho&#8221; (porém poderoso) iPhone 7 liderando as vendas nacionais. Mas comprar um iPhone seminovo não é algo que se deva fazer sem tomar alguns cuidados, pois sabemos de várias histórias de pessoas que compraram um aparelho em alguns classificados online com preço muito atrativo para acabar recebendo um tijolo pelos Correios.</p><p>Não podemos esquecer, também, dos riscos de comprar um aparelho com defeito, bloqueado ou até mesmo roubado. Por isso, tome muito cuidado com iPhones muito baratos — ainda que pareça uma boa compra, pode se tornar uma tremenda dor de cabeça.</p><p>Então o que você deve fazer para conseguir comprar um iPhone seminovo sem correr riscos?</p><h2>iPhone com procedência</h2><p>A primeira coisa que você deve investigar é a procedência desse aparelho e a reputação do vendedor. Quando queremos pagar mais barato, os classificados tendem a ser nossa melhor opção, mas os riscos são muito grandes. Quem se sente seguro encontrando um desconhecido levando mais de R$1.000 em dinheiro para comprar um <em>device</em>? Não sei você, mas eu prefiro não arriscar.</p><p>Para eliminar os riscos, só nos resta ir atrás de lojas confiáveis que vendam esses aparelhos usados, mas aí os preços acabam sendo mais salgados — e, muitas vezes, o seu tão sonhado iPhone 11 acaba se tornando um iPhone XR para caber no bolso.</p><h2>Compare, sempre!</h2><p>A solução para conseguir comprar o iPhone dos sonhos é pesquisar por aí e comparar os preços, que podem variar em até 15-20%, a depender do modelo, nas lojas que vendem seminovos.</p><p>Um iPhone XS Max de 256GB cinza espacial na líder de vendas de smartphones usados não sai por menos de R$4.259, por exemplo. Já o mesmo <a href="https://store.icaiu.com.br/?utm_source=macmagazine&amp;utm_medium=publipos&amp;utm_campaign=natalstore2021&amp;utm_id=publimacmagazine">iPhone na iCaiu Store</a>,<a href="https://store.icaiu.com.br/buy/product/iphone-xs-max-256GB-cinzaespacial-5564437?utm_source=macmagazine&amp;utm_medium=publipos&amp;utm_campaign=natalstore2021&amp;utm_id=publimacmagazine">sai por apenas R$3.970</a>, quase R$300 mais barato. Com essa diferença, você poderia comprar todos os acessórios necessários para deixar seu aparelho &#8220;pronto para a guerra&#8221;.</p><h2>Onde comprar um iPhone barato com garantia?</h2><p>Nenhuma loja de smartphones usados oferece uma garantia tão longa quanto a iCaiu. A rede especializada em <em>devices</em> Apple com mais de 20 lojas em<a href="https://www.icaiu.com.br/local/sao-paulo/?utm_source=macmagazine&amp;utm_medium=publipos&amp;utm_campaign=natalstore2021&amp;utm_id=publimacmagazine">São Paulo</a>,<a href="https://www.icaiu.com.br/local/rio-de-janeiro/?utm_source=macmagazine&amp;utm_medium=publipos&amp;utm_campaign=natalstore2021&amp;utm_id=publimacmagazine">Rio de Janeiro</a>,<a href="https://www.icaiu.com.br/local/sao-paulo/campinas/?utm_source=macmagazine&amp;utm_medium=publipos&amp;utm_campaign=natalstore2021&amp;utm_id=publimacmagazine">Campinas</a> e<a href="https://www.icaiu.com.br/local/distrito-federal/?utm_source=macmagazine&amp;utm_medium=publipos&amp;utm_campaign=natalstore2021&amp;utm_id=publimacmagazine">Distrito Federal</a> é a única onde todos os aparelhos possuem<strong>seis meses de garantia</strong>.</p><div class="wp-block-image"><figure class="aligncenter size-large"><img width="1260" height="840" src="https://macmagazine.com.br/wp-content/uploads/2021/12/sara-kurfess-KegwEO8r29E-unsplash-1260x840.jpg" alt="" class="wp-image-841728" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/sara-kurfess-KegwEO8r29E-unsplash-1260x840.jpg 1260w, https://macmagazine.com.br/wp-content/uploads/2021/12/sara-kurfess-KegwEO8r29E-unsplash-600x400.jpg 600w, https://macmagazine.com.br/wp-content/uploads/2021/12/sara-kurfess-KegwEO8r29E-unsplash-300x200.jpg 300w, https://macmagazine.com.br/wp-content/uploads/2021/12/sara-kurfess-KegwEO8r29E-unsplash-1536x1024.jpg 1536w, https://macmagazine.com.br/wp-content/uploads/2021/12/sara-kurfess-KegwEO8r29E-unsplash-2048x1365.jpg 2048w, https://macmagazine.com.br/wp-content/uploads/2021/12/sara-kurfess-KegwEO8r29E-unsplash-380x253.jpg 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/sara-kurfess-KegwEO8r29E-unsplash-800x533.jpg 800w, https://macmagazine.com.br/wp-content/uploads/2021/12/sara-kurfess-KegwEO8r29E-unsplash-1160x773.jpg 1160w" sizes="(max-width: 1260px) 100vw, 1260px" /></figure></div><p>Isso só é possível porque a iCaiu possui uma grande estrutura voltada a reparos de todos os tipos de aparelhos da Apple, com técnicos especializados. Isso permite com que a inovadora empresa, que oferece uma gama de serviços para nós, <em>Applemaníacos</em>, consiga garantir a procedência e a qualidade de todos os dispositivos comercializados pela iCaiu Store, o melhor<em>marketplace</em> entre donos de aparelhos da marca que nós tanto amamos.</p><p>Tendo cerca de 70 mil clientes satisfeitos e com um <em>marketplace</em> inovador, só a iCaiu consegue oferecer iPhones com preços próximos aos encontrados nos arriscados classificados, porém com a segurança de uma loja especializada. Além dos preços quase imbatíveis em todos os iPhones, a garantia de seis meses e o<strong>parcelamento em 10x sem juros</strong>, você não precisa ficar esperando sua compra chegar em casa nem correr o risco de ter seu novo iPhone extraviado, pois você pode ir em qualquer uma de<a href="https://www.icaiu.com.br/lojas/?utm_source=macmagazine&amp;utm_medium=publipos&amp;utm_campaign=natalstore2021&amp;utm_id=publimacmagazine">nossas lojas</a> retirar pessoalmente o seu aparelho.</p><p>Mas não pense que as vantagens param por aí: segundo o Código de Defesa do Consumidor, todos os produtos que você compra pela internet têm sete dias para serem devolvidos — e você, o seu dinheiro de volta. Isso é uma garantia para caso você se arrependa da sua compra, uma vez que você adquiriu o produto sem poder vê-lo fisicamente.</p><p>Mas a iCaiu, tendo tanta certeza de que você sairá satisfeito, oferece incríveis 15 dias de prazo para devolução, mesmo a compra sendo entregue fisicamente e não pelos Correios. Somente quem tem certeza da qualidade dos iPhones vendidos pode fazer uma coisa dessas! Por essas e outras, a iCaiu foi indicada ao <strong>Prêmio Reclame Aqui</strong> como a<strong>melhor <a href="https://www.icaiu.com.br/?utm_source=macmagazine&amp;utm_medium=publipos&amp;utm_campaign=natalstore2021&amp;utm_id=publimacmagazine">Assistência Técnica Apple</a> do Brasil</strong>.</p><h2>E se eu quiser comprar um iPhone 13, o que eu posso fazer?</h2><figure class="wp-block-gallery aligncenter columns-2 is-cropped"><ul class="blocks-gallery-grid"><li class="blocks-gallery-item"><figure><img width="828" height="1424" src="https://macmagazine.com.br/wp-content/uploads/2021/12/IMG_5315.jpg" alt="" data-id="841730" data-full-url="https://macmagazine.com.br/wp-content/uploads/2021/12/IMG_5315.jpg" data-link="https://macmagazine.com.br/?attachment_id=841730" class="wp-image-841730" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/IMG_5315.jpg 828w, https://macmagazine.com.br/wp-content/uploads/2021/12/IMG_5315-349x600.jpg 349w, https://macmagazine.com.br/wp-content/uploads/2021/12/IMG_5315-733x1260.jpg 733w, https://macmagazine.com.br/wp-content/uploads/2021/12/IMG_5315-174x300.jpg 174w, https://macmagazine.com.br/wp-content/uploads/2021/12/IMG_5315-380x654.jpg 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/IMG_5315-800x1376.jpg 800w" sizes="(max-width: 828px) 100vw, 828px" /></figure></li><li class="blocks-gallery-item"><figure><img width="828" height="1428" src="https://macmagazine.com.br/wp-content/uploads/2021/12/IMG_5314.jpg" alt="" data-id="841729" data-full-url="https://macmagazine.com.br/wp-content/uploads/2021/12/IMG_5314.jpg" data-link="https://macmagazine.com.br/?attachment_id=841729" class="wp-image-841729" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/IMG_5314.jpg 828w, https://macmagazine.com.br/wp-content/uploads/2021/12/IMG_5314-348x600.jpg 348w, https://macmagazine.com.br/wp-content/uploads/2021/12/IMG_5314-731x1260.jpg 731w, https://macmagazine.com.br/wp-content/uploads/2021/12/IMG_5314-174x300.jpg 174w, https://macmagazine.com.br/wp-content/uploads/2021/12/IMG_5314-380x655.jpg 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/IMG_5314-800x1380.jpg 800w" sizes="(max-width: 828px) 100vw, 828px" /></figure></li></ul></figure><p>Então você é um <em>early-adopter</em> que está sempre na frente de todo mundo quando o assunto é tecnologia e, principalmente, produtos da Apple? Ficou com a mão coçando em setembro com o lançamento do novo iPhone, mas como os preços são muito salgados ainda não conseguiu adquirir o seu? A iCaiu também é para você!</p><p>Infelizmente nosso foco é em seminovos com garantia, então até este momento só temos aparelhos da linha do iPhone 12, como um <a href="https://store.icaiu.com.br/buy/product/iphone-12-pro?utm_source=macmagazine&amp;utm_medium=publipos&amp;utm_campaign=natalstore2021&amp;utm_id=publimacmagazine">iPhone 12 Pro Max de 256GB branco</a>, que sai por apenas 10x de R$720. Mas não vamos lhe deixar na mão!</p><p>Vendendo seu iPhone antigo na iCaiu Store, você recebe mais por ele do que na empresa líder de mercado, porém sem a dor de cabeça de vender por conta própria para outra pessoa.</p><p>“Ah, mas meu iPhone 11 está com a tela trincada. Ninguém vai querer comprá-lo.&#8221; Se o seu iPhone precisa de reparos, a iCaiu também quebra esse galho para você! Vendendo ele pela iCaiu Store, você ganha 30% de desconto para a realização do reparo e só paga quando o seu aparelho for vendido, ou seja, não é cobrado nada na hora do reparo. Os custos do conserto são descontados do valor que você receberá com a venda ou em alguns poucos dias, caso você queira receber o valor antecipadamente.</p><p>Mesmo que você não esteja planejando comprar o novo iPhone mas está apertado, precisando de uma grana boa, entre no site da iCaiu e <a href="https://store.icaiu.com.br/vender_iphone/usado?utm_source=macmagazine&amp;utm_medium=publipos&amp;utm_campaign=natalstore2021&amp;utm_id=publimacmagazine">faça uma avaliação do seu aparelho para ver quanto ele vale</a>. É garantia de que você encontrará o melhor preço oferecido pelo seu aparelho antigo.</p><h2>Desconto de Natal</h2><p>Agora que você já sabe das vantagens de <a href="https://store.icaiu.com.br/comprar">comprar um iPhone seminovo</a> e que pode descolar um bom dinheiro vendendo seu aparelho usado, que tal aproveitar o momento em que você está com um extra na carteira e dar aquele presente inesquecível para aquela pessoa especial que você ama tanto?</p><div class="wp-block-image"><figure class="aligncenter size-large"><img width="1008" height="1260" src="https://macmagazine.com.br/wp-content/uploads/2021/12/kevin-bhagat-Co-usQ-kpO0-unsplash-1008x1260.jpg" alt="" class="wp-image-841732" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/kevin-bhagat-Co-usQ-kpO0-unsplash-1008x1260.jpg 1008w, https://macmagazine.com.br/wp-content/uploads/2021/12/kevin-bhagat-Co-usQ-kpO0-unsplash-480x600.jpg 480w, https://macmagazine.com.br/wp-content/uploads/2021/12/kevin-bhagat-Co-usQ-kpO0-unsplash-240x300.jpg 240w, https://macmagazine.com.br/wp-content/uploads/2021/12/kevin-bhagat-Co-usQ-kpO0-unsplash-1229x1536.jpg 1229w, https://macmagazine.com.br/wp-content/uploads/2021/12/kevin-bhagat-Co-usQ-kpO0-unsplash-1638x2048.jpg 1638w, https://macmagazine.com.br/wp-content/uploads/2021/12/kevin-bhagat-Co-usQ-kpO0-unsplash-380x475.jpg 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/kevin-bhagat-Co-usQ-kpO0-unsplash-800x1000.jpg 800w, https://macmagazine.com.br/wp-content/uploads/2021/12/kevin-bhagat-Co-usQ-kpO0-unsplash-1160x1450.jpg 1160w, https://macmagazine.com.br/wp-content/uploads/2021/12/kevin-bhagat-Co-usQ-kpO0-unsplash-scaled.jpg 3277w" sizes="(max-width: 1008px) 100vw, 1008px" /></figure></div><p>Dia 25/12 está chegando, mas ainda dá tempo de comprar um excelente iPhone na iCaiu Store para dar de presente para alguém — ou, quem sabe, um mais do que merecido de você para você mesmo, pois nós sabemos que este ano não foi fácil e você lutou bravamente!</p><p>Nada mais justo do que realizar aquele seu sonho antigo de ter um iPhone <em>top</em> para começar 2022 com a corda toda.<img src="https://s.w.org/images/core/emoji/13.1.0/72x72/1f601.png" alt="😁" class="wp-smiley" style="height: 1em; max-height: 1em;" /><br><br>E, para facilitar ainda mais, a iCaiu está dando um desconto para os fãs do <em>MM</em>. Usando o cupom<code>MACMAGAZINE10</code>, você terá<strong>10% de desconto</strong> em qualquer aparelho no site da iCaiu Store se comprar no site até o dia 22/12. Então corra e garanta logo o seu porque temos<strong>estoque limitado</strong>!</p><ul><li><strong>Cupom</strong>:<code>MACMAGAZINE10</code></li><li><strong>Validade:</strong> 22 de dezembro de 2021</li><li><strong>Onde</strong>: no site<a href="http://store.icaiu.com.br">store.icaiu.com.br</a></li><li><strong>Retirada em lojas físicas</strong>: Rio de Janeiro, São Paulo, Brasília e Campinas</li></ul><p>Ah, os preços da iCaiu Store citados no texto acima estão *sem* o desconto extra de Natal para os leitores do <em><strong>MacMagazine</strong></em>, hein! <img src="https://s.w.org/images/core/emoji/13.1.0/72x72/1f609.png" alt="😉" class="wp-smiley" style="height: 1em; max-height: 1em;" />&nbsp;</p>
]]>
</content:encoded>
<wfw:commentRss>https://macmagazine.com.br/post/2021/12/16/um-iphone-seminovo-pode-ser-aquele-superpresente/feed/</wfw:commentRss>
<slash:comments>0</slash:comments>
<post-id xmlns="com-wordpress:feed-additions:1">841639</post-id>
<media:content xmlns:media="http://search.yahoo.com/mrss/" medium="image" type="image/jpeg" url="https://macmagazine.com.br/wp-content/uploads/2021/12/sabri-tuzcu-rYnQwRsNpE0-unsplash-1260x840.jpg" width="1200" height="800" />
</item>
<item>
    <title>Pesquisadores revelam detalhes por trás dos ataques do NSO Group</title>
    <link>https://macmagazine.com.br/post/2021/12/16/pesquisadores-revelam-detalhes-por-tras-dos-ataques-do-nso-group/</link>
    <comments>https://macmagazine.com.br/post/2021/12/16/pesquisadores-revelam-detalhes-por-tras-dos-ataques-do-nso-group/#respond</comments>
    <dc:creator>
        <![CDATA[Diogo Ammon]]>
    </dc:creator>
    <pubDate>Thu, 16 Dec 2021 11:30:00 +0000</pubDate>
    <category>
        <![CDATA[Internet]]>
    </category>
    <category>
        <![CDATA[Segurança]]>
    </category>
    <category>
        <![CDATA[Software]]>
    </category>
    <category>
        <![CDATA[Apple]]>
    </category>
    <category>
        <![CDATA[Ataques]]>
    </category>
    <category>
        <![CDATA[exploits]]>
    </category>
    <category>
        <![CDATA[FORCEDENTRY]]>
    </category>
    <category>
        <![CDATA[iMessage]]>
    </category>
    <category>
        <![CDATA[invasão]]>
    </category>
    <category>
        <![CDATA[iPhones]]>
    </category>
    <category>
        <![CDATA[NSO Group]]>
    </category>
    <category>
        <![CDATA[Pegasus]]>
    </category>
    <category>
        <![CDATA[pesquisadores]]>
    </category>
    <category>
        <![CDATA[privacidade]]>
    </category>
    <category>
        <![CDATA[Project Zero]]>
    </category>
    <category>
        <![CDATA[Sistema]]>
    </category>
    <category>
        <![CDATA[Spyware]]>
    </category>
    <category>
        <![CDATA[zero-click]]>
    </category>
    <guid isPermaLink="false">https://macmagazine.com.br/?p=841630</guid>
    <description>
        <![CDATA[Já falamos diversas vezes sobre o NSO Group, criador do Pegasus — spyware utilizado para invadir dispositivos ilegal&#8230;]]>
    </description>
    <content:encoded>
        <![CDATA[<img width="1200" height="800" src="https://macmagazine.com.br/wp-content/uploads/2021/12/03-NSO-Apple-logo-1260x840.jpg" class="webfeedsFeaturedVisual wp-post-image" alt="Logo do NSO Group e da Apple" style="display: block; margin: auto; margin-bottom: 5px;max-width: 100%;" link_thumbnail="" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/03-NSO-Apple-logo-1260x840.jpg 1260w, https://macmagazine.com.br/wp-content/uploads/2021/12/03-NSO-Apple-logo-600x400.jpg 600w, https://macmagazine.com.br/wp-content/uploads/2021/12/03-NSO-Apple-logo-300x200.jpg 300w, https://macmagazine.com.br/wp-content/uploads/2021/12/03-NSO-Apple-logo-1536x1024.jpg 1536w, https://macmagazine.com.br/wp-content/uploads/2021/12/03-NSO-Apple-logo-2048x1366.jpg 2048w, https://macmagazine.com.br/wp-content/uploads/2021/12/03-NSO-Apple-logo-380x253.jpg 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/03-NSO-Apple-logo-800x533.jpg 800w, https://macmagazine.com.br/wp-content/uploads/2021/12/03-NSO-Apple-logo-1160x773.jpg 1160w" sizes="(max-width: 1200px) 100vw, 1200px" /><p>Já falamos diversas vezes <a href="https://macmagazine.com.br/sobre/nso-group/">sobre o <strong>NSO Group</strong></a>, criador do <strong><a href="https://macmagazine.com.br/sobre/pegasus/">Pegasus</a></strong> — <em>spyware</em> utilizado para invadir dispositivos ilegal e silenciosamente.</p><p>Recentemente, <a href="https://googleprojectzero.blogspot.com/2021/12/a-deep-dive-into-nso-zero-click.html">pesquisadores de segurança do <strong>Google</strong> mergulharam profundamente</a> no no <a href="https://macmagazine.com.br/post/2021/07/19/imessage-e-vulneravel-a-spyware-israelense-no-ios-14-6/"><em>exploit zero-click</em> do iMessage</a> (já corrigido pela Apple), utilizado pelo NSO, e descobriram ainda mais informações por trás da sua sofisticada e assustadora operação da forma.</p><p>De acordo com pesquisadores do <strong>Project Zero</strong>, o<em>exploit zero-click</em><strong>ForcedEntry</strong> — o qual foi utilizado para atingir ativistas e jornalistas — é um dos mais sofisticados tecnicamente já vistos por eles.</p><p>A coisa é tão elaborada que o NSO conseguia atingir usuários apenas pelo fato de estarem usando o iMessage — se utilizando de uma vulnerabilidade no sistema de decodificação de arquivos GIF do mensageiro. Por meio desse processo, o <em>spyware</em> conseguia enganar a plataforma para abrir diversos PDFs maliciosos sem qualquer interação do usuário — obtendo, depois, controle total do aparelho.</p><p>A vulnerabilidade, em particular, estava relacionada a uma antiga ferramenta de compressão utilizada pela Apple para reconhecer textos em fotos. O método de infecção do ForcedEntry era tão engenhoso que, para evitar ser detectado, virtualizava seus comandos em um ambiente virtual em vez de comunicá-los a um servidor.</p><p>Até onde se sabe, esses tipos de ataques já foram utilizados diversas vezes contra ativistas, jornalistas e políticos — tanto é que o NSO entrou para a lista de <a href="https://macmagazine.com.br/post/2021/11/04/criadora-do-spyware-pegasus-esta-na-lista-de-ameacas-dos-eua/">ameaças de segurança nacional dos Estados Unidos</a>.</p><p>Em novembro último, a Apple iniciou um processo contra o NSO Group <a href="https://macmagazine.com.br/post/2021/11/23/apple-processa-nso-group-por-ataques-com-spyware-pegasus/">para que eles fossem responsabilizados por ataques a iPhones</a>. Mais recentemente, seja relacionado a isso ou não, fontes indicam que a empresa estaria tentando limpar a sua imagem e estaria<a href="https://macmagazine.com.br/post/2021/12/14/nso-group-podera-encerrar-atividades-com-spyware-pegasus/">disposta a encerrar as atividades do <em>spyware</em> Pegasus</a>.</p>
]]>
</content:encoded>
<wfw:commentRss>https://macmagazine.com.br/post/2021/12/16/pesquisadores-revelam-detalhes-por-tras-dos-ataques-do-nso-group/feed/</wfw:commentRss>
<slash:comments>0</slash:comments>
<post-id xmlns="com-wordpress:feed-additions:1">841630</post-id>
<media:content xmlns:media="http://search.yahoo.com/mrss/" medium="image" type="image/jpeg" url="https://macmagazine.com.br/wp-content/uploads/2021/12/03-NSO-Apple-logo-1260x840.jpg" width="1200" height="800" />
</item>
<item>
    <title>Instagram testa vídeos de até 60 segundos nos Stories</title>
    <link>https://macmagazine.com.br/post/2021/12/16/instagram-testa-videos-de-ate-60-segundos-nos-stories/</link>
    <comments>https://macmagazine.com.br/post/2021/12/16/instagram-testa-videos-de-ate-60-segundos-nos-stories/#respond</comments>
    <dc:creator>
        <![CDATA[Diogo Ammon]]>
    </dc:creator>
    <pubDate>Thu, 16 Dec 2021 11:00:00 +0000</pubDate>
    <category>
        <![CDATA[Internet]]>
    </category>
    <category>
        <![CDATA[Software]]>
    </category>
    <category>
        <![CDATA[Vídeos]]>
    </category>
    <category>
        <![CDATA[60 segundos]]>
    </category>
    <category>
        <![CDATA[Facebook]]>
    </category>
    <category>
        <![CDATA[Instagram]]>
    </category>
    <category>
        <![CDATA[Instagram Stories]]>
    </category>
    <category>
        <![CDATA[meta]]>
    </category>
    <category>
        <![CDATA[novidade]]>
    </category>
    <category>
        <![CDATA[rede]]>
    </category>
    <category>
        <![CDATA[rede social]]>
    </category>
    <category>
        <![CDATA[Stories]]>
    </category>
    <category>
        <![CDATA[testes]]>
    </category>
    <category>
        <![CDATA[usuários]]>
    </category>
    <category>
        <![CDATA[vídeos mais longos]]>
    </category>
    <guid isPermaLink="false">https://macmagazine.com.br/?p=841644</guid>
    <description>
        <![CDATA[O Instagram já estava testando a função com alguns usuários, mas parece que a rede finalmente começará a&#8230;]]>
    </description>
    <content:encoded>
        <![CDATA[<img width="1200" height="800" src="https://macmagazine.com.br/wp-content/uploads/2021/12/15-instagram-1260x840.jpg" class="webfeedsFeaturedVisual wp-post-image" alt="Instagram" style="display: block; margin: auto; margin-bottom: 5px;max-width: 100%;" link_thumbnail="" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/15-instagram-1260x840.jpg 1260w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-instagram-600x400.jpg 600w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-instagram-300x200.jpg 300w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-instagram-1536x1024.jpg 1536w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-instagram-2048x1365.jpg 2048w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-instagram-380x253.jpg 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-instagram-800x533.jpg 800w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-instagram-1160x773.jpg 1160w" sizes="(max-width: 1200px) 100vw, 1200px" /><p>O <strong>Instagram</strong> já estava testando a função com alguns usuários, mas parece que a rede finalmente começará a permitir a postagem de vídeos mais longos — de até 60 segundos — nos<em><strong>Stories</strong></em>.</p><p>Até agora, esse limite é de 15 segundos. Como de costume, vídeos mais longos do que isso são seccionados em diversas partes.</p><p>A novidade foi descoberta por um usuário da rede da Turquia e noticiada pelo <em>insider</em><strong>Matt Navarra</strong>:</p><figure class="wp-block-embed aligncenter is-type-rich is-provider-twitter wp-block-embed-twitter"><div class="wp-block-embed__wrapper"><blockquote class="twitter-tweet" data-width="550" data-dnt="true"><p lang="en" dir="ltr">Instagram is testing longer stories segments of up-to 60 seconds <br><br>Spotted by <a href="https://twitter.com/yousufortaccom?ref_src=twsrc%5Etfw">@yousufortaccom</a> in Turkey<a href="https://t.co/6LJ2Rjqbpz">pic.twitter.com/6LJ2Rjqbpz</a></p>&mdash; Matt Navarra (@MattNavarra) <a href="https://twitter.com/MattNavarra/status/1471199503076274185?ref_src=twsrc%5Etfw">December 15, 2021</a></blockquote><script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script></div><figcaption>O Instagram está testando segmentos de histórias mais longas de até 60 segundos</figcaption></figure><p>O app começou a notificar alguns usuários sobre a mudança recentemente, mas não se sabe ao certo quando o recurso estará de fato liberado para todos os usuários.</p><p>E aí, o aviso já apareceu no seu aplicativo?</p><hr /><div class="appbox"><div class="appbox-icon"><a href="https://apps.apple.com/br/app/instagram/id389801252" target="_blank"><img class="appbox-iconiOS" alt="&Iacute;cone do app Instagram" src="https://is5-ssl.mzstatic.com/image/thumb/Purple116/v4/ed/56/c2/ed56c249-8f1c-10c5-af47-7ccac7fdec29/Prod-0-0-1x_U007emarketing-0-0-0-7-0-0-sRGB-0-0-0-GLES2_U002c0-512MB-85-220-0-0.png/256x256bb.png" /></a></div><div class="appbox-details"><span class="appbox-name"><a href="https://apps.apple.com/br/app/instagram/id389801252" target="_blank">Instagram</a></span><span class="appbox-de">de <strong><a href="http://instagram.com/" target="_blank" class="no_icon" rel="nofollow">Instagram, Inc.</a></strong></span><div class="appbox-devices"><img src="https://macmagazine.com.br/wp-content/uploads/2015/11/devices_iphone.png" alt="Compat&iacute;vel com iPhones" title="Compat&iacute;vel com iPhones" class="appbox-devicesiPhone" /></div><div class="appbox-info">Vers&atilde;o <strong>216.0</strong> (197.5 MB)<br />
                    Requer o <strong>iOS 12.0</strong> ou superior</div></div><div class="appbox-badge"><span class="appbox-price">Gr&aacute;tis</span><span><a href="https://apps.apple.com/br/app/instagram/id389801252" target="_blank"><img alt="Badge - Baixar na App Store" src="https://macmagazine.com.br/wp-content/uploads/2017/11/22-badge_appstore.png" class="badgeInvert" /></a></span><span class="appbox-QRcode"><a href="javascript:void(0);" title="C&oacute;digo QR - Instagram" onclick="javascript:abrirQR('https://chart.googleapis.com/chart?chs=400x400&cht=qr&chl=https%3A%2F%2Fapps.apple.com%2Fbr%2Fapp%2Finstagram%2Fid389801252&chld=L|0');return false;"><img alt="C&oacute;digo QR" src="https://macmagazine.com.br/wp-content/themes/newsblock-child/images/qr.png" /></a><a href="javascript:void(0);" title="C&oacute;digo QR - Instagram" onclick="javascript:abrirQR('https://chart.googleapis.com/chart?chs=400x400&cht=qr&chl=https%3A%2F%2Fapps.apple.com%2Fbr%2Fapp%2Finstagram%2Fid389801252&chld=L|0');return false;">C&oacute;digo QR</a></span></div>
                </div>
]]>
</content:encoded>
<wfw:commentRss>https://macmagazine.com.br/post/2021/12/16/instagram-testa-videos-de-ate-60-segundos-nos-stories/feed/</wfw:commentRss>
<slash:comments>0</slash:comments>
<post-id xmlns="com-wordpress:feed-additions:1">841644</post-id>
<media:content xmlns:media="http://search.yahoo.com/mrss/" medium="image" type="image/jpeg" url="https://macmagazine.com.br/wp-content/uploads/2021/12/15-instagram-1260x840.jpg" width="1200" height="800" />
</item>
<item>
    <title>Como ouvir um áudio antes de enviar pelo WhatsApp [iPhone]</title>
    <link>https://macmagazine.com.br/post/2021/12/16/como-ouvir-um-audio-antes-de-enviar-pelo-whatsapp-iphone/</link>
    <comments>https://macmagazine.com.br/post/2021/12/16/como-ouvir-um-audio-antes-de-enviar-pelo-whatsapp-iphone/#respond</comments>
    <dc:creator>
        <![CDATA[Pedro Henrique Nunes]]>
    </dc:creator>
    <pubDate>Thu, 16 Dec 2021 10:40:00 +0000</pubDate>
    <category>
        <![CDATA[Dicas]]>
    </category>
    <category>
        <![CDATA[Software]]>
    </category>
    <category>
        <![CDATA[Tutoriais]]>
    </category>
    <category>
        <![CDATA[áudio]]>
    </category>
    <category>
        <![CDATA[dica]]>
    </category>
    <category>
        <![CDATA[iPhone]]>
    </category>
    <category>
        <![CDATA[mensageiro]]>
    </category>
    <category>
        <![CDATA[mensageiro instantâneo]]>
    </category>
    <category>
        <![CDATA[mensagens de áudio]]>
    </category>
    <category>
        <![CDATA[mensagens de voz]]>
    </category>
    <category>
        <![CDATA[tutorial]]>
    </category>
    <category>
        <![CDATA[WhatsApp]]>
    </category>
    <category>
        <![CDATA[WhatsApp Messenger]]>
    </category>
    <guid isPermaLink="false">https://macmagazine.com.br/?p=841475</guid>
    <description>
        <![CDATA[Conforme já noticiamos por aqui, o WhatsApp Messenger finalmente começou a liberar uma atualização que permite ouvir os&#8230;]]>
    </description>
    <content:encoded>
        <![CDATA[<img width="1200" height="800" src="https://macmagazine.com.br/wp-content/uploads/2021/05/07-whatsapp-2-1260x840.jpg" class="webfeedsFeaturedVisual wp-post-image" alt="WhatsApp" style="display: block; margin: auto; margin-bottom: 5px;max-width: 100%;" link_thumbnail="" srcset="https://macmagazine.com.br/wp-content/uploads/2021/05/07-whatsapp-2-1260x840.jpg 1260w, https://macmagazine.com.br/wp-content/uploads/2021/05/07-whatsapp-2-600x400.jpg 600w, https://macmagazine.com.br/wp-content/uploads/2021/05/07-whatsapp-2-300x200.jpg 300w, https://macmagazine.com.br/wp-content/uploads/2021/05/07-whatsapp-2-1536x1024.jpg 1536w, https://macmagazine.com.br/wp-content/uploads/2021/05/07-whatsapp-2-2048x1365.jpg 2048w, https://macmagazine.com.br/wp-content/uploads/2021/05/07-whatsapp-2-380x253.jpg 380w, https://macmagazine.com.br/wp-content/uploads/2021/05/07-whatsapp-2-800x533.jpg 800w, https://macmagazine.com.br/wp-content/uploads/2021/05/07-whatsapp-2-1160x773.jpg 1160w" sizes="(max-width: 1200px) 100vw, 1200px" /><p>Conforme já <a href="https://macmagazine.com.br/post/2021/12/15/whatsapp-ja-permite-ouvir-audios-antes-de-envia-los/">noticiamos por aqui</a>, o<strong>WhatsApp Messenger</strong> finalmente começou a liberar uma atualização que permite ouvir os áudios antes de enviá-los a um contato ou grupo.</p><p>Há um tempo, até mostramos como você poderia fazer isso usando uma <a href="https://macmagazine.com.br/post/2021/05/31/como-ouvir-um-audio-antes-de-envia-lo-no-whatsapp/">gambiarra muito simples</a>, mas agora é possível fazer isso &#8220;oficialmente&#8221;, de uma forma muito mais simples e eficaz.</p><div class="wp-block-group posts-relacionados"><div class="wp-block-group__inner-container"><p><b>Posts relacionados</b></p><ul><li><a href="https://macmagazine.com.br/post/2021/12/14/video-dicas-para-voce-economizar-espaco-no-whatsapp/">Vídeo: dicas para você economizar espaço no WhatsApp!</a></li><li><a href="https://macmagazine.com.br/post/2021/12/13/como-editar-fotos-videos-pelo-whatsapp-iphone-mac-e-web/">Como editar fotos/vídeos pelo WhatsApp [iPhone, Mac e web]</a></li><li><a href="https://macmagazine.com.br/post/2021/12/13/como-fixar-mensagens-no-whatsapp-iphone-mac-e-web/">Como fixar mensagens no WhatsApp [iPhone, Mac e web]</a></li></ul></div></div><p>Assim, fica fácil cancelar o envio caso você se arrependa de alguma coisa que tenha dito, da forma como tudo foi falado ou simplesmente não queira mais mandar a mensagem para uma pessoa ou um grupo no mensageiro depois de escutá-la. <img src="https://s.w.org/images/core/emoji/13.1.0/72x72/1f61b.png" alt="😛" class="wp-smiley" style="height: 1em; max-height: 1em;" /></p><p>Veja só como é simples fazer isso: pelo iPhone, abra o WhatsApp e selecione a conversa individual ou o grupo para o qual deseja enviar a mensagem de áudio. </p><p>Em seguida, pressione e segure o dedo sobre o ícone de microfone e arraste-o para cima (o que o WhatsApp chama de gravação com as mãos livres). Comece a falar para que o áudio seja capturado e, quando estiver satisfeito, toque no botão vermelho de parar (<em>stop</em>) a gravação.</p><div class="wp-block-image"><figure class="aligncenter size-large"><a href="https://macmagazine.com.br/wp-content/uploads/2021/12/15-ouvir-audio-whatsapp.png"><img width="1260" height="817" src="https://macmagazine.com.br/wp-content/uploads/2021/12/15-ouvir-audio-whatsapp-1260x817.png" alt="" class="wp-image-841493" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/15-ouvir-audio-whatsapp-1260x817.png 1260w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-ouvir-audio-whatsapp-600x389.png 600w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-ouvir-audio-whatsapp-300x194.png 300w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-ouvir-audio-whatsapp-1536x996.png 1536w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-ouvir-audio-whatsapp-2048x1328.png 2048w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-ouvir-audio-whatsapp-380x246.png 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-ouvir-audio-whatsapp-800x519.png 800w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-ouvir-audio-whatsapp-1160x752.png 1160w" sizes="(max-width: 1260px) 100vw, 1260px" /></a></figure></div><p>Depois, toque no botão de reproduzir <meta charset="utf-8">para ouvir o áudio. Caso queira apagá-lo, toque no ícone de lixeira ou, se estiver satisfeito e quiser enviá-lo, toque no botão com a seta azul. </p><p>Muito bom! <img src="https://s.w.org/images/core/emoji/13.1.0/72x72/1f399.png" alt="🎙" class="wp-smiley" style="height: 1em; max-height: 1em;" /><img src="https://s.w.org/images/core/emoji/13.1.0/72x72/1f4f1.png" alt="📱" class="wp-smiley" style="height: 1em; max-height: 1em;" /></p><hr /><div class="appbox"><div class="appbox-icon"><a href="https://apps.apple.com/br/app/whatsapp-messenger/id310633997" target="_blank"><img class="appbox-iconiOS" alt="&Iacute;cone do app WhatsApp Messenger" src="https://is4-ssl.mzstatic.com/image/thumb/Purple126/v4/9d/3f/bf/9d3fbfad-11ca-1781-d7c1-508959f40003/AppIcon-0-0-1x_U007emarketing-0-0-0-6-0-0-sRGB-0-0-0-GLES2_U002c0-512MB-85-220-0-0.png/256x256bb.png" /></a></div><div class="appbox-details"><span class="appbox-name"><a href="https://apps.apple.com/br/app/whatsapp-messenger/id310633997" target="_blank">WhatsApp Messenger</a></span><span class="appbox-de">de <strong><a href="http://www.whatsapp.com/" target="_blank" class="no_icon" rel="nofollow">WhatsApp Inc.</a></strong></span><div class="appbox-devices"><img src="https://macmagazine.com.br/wp-content/uploads/2015/11/devices_iphone.png" alt="Compat&iacute;vel com iPhones" title="Compat&iacute;vel com iPhones" class="appbox-devicesiPhone" /></div><div class="appbox-info">Vers&atilde;o <strong>2.21.241</strong> (204 MB)<br />
                    Requer o <strong>iOS 10.0</strong> ou superior</div></div><div class="appbox-badge"><span class="appbox-price">Gr&aacute;tis</span><span><a href="https://apps.apple.com/br/app/whatsapp-messenger/id310633997" target="_blank"><img alt="Badge - Baixar na App Store" src="https://macmagazine.com.br/wp-content/uploads/2017/11/22-badge_appstore.png" class="badgeInvert" /></a></span><span class="appbox-QRcode"><a href="javascript:void(0);" title="C&oacute;digo QR - WhatsApp Messenger" onclick="javascript:abrirQR('https://chart.googleapis.com/chart?chs=400x400&cht=qr&chl=https%3A%2F%2Fapps.apple.com%2Fbr%2Fapp%2Fwhatsapp-messenger%2Fid310633997&chld=L|0');return false;"><img alt="C&oacute;digo QR" src="https://macmagazine.com.br/wp-content/themes/newsblock-child/images/qr.png" /></a><a href="javascript:void(0);" title="C&oacute;digo QR - WhatsApp Messenger" onclick="javascript:abrirQR('https://chart.googleapis.com/chart?chs=400x400&cht=qr&chl=https%3A%2F%2Fapps.apple.com%2Fbr%2Fapp%2Fwhatsapp-messenger%2Fid310633997&chld=L|0');return false;">C&oacute;digo QR</a></span></div>
                </div>
]]>
</content:encoded>
<wfw:commentRss>https://macmagazine.com.br/post/2021/12/16/como-ouvir-um-audio-antes-de-enviar-pelo-whatsapp-iphone/feed/</wfw:commentRss>
<slash:comments>0</slash:comments>
<post-id xmlns="com-wordpress:feed-additions:1">841475</post-id>
<media:content xmlns:media="http://search.yahoo.com/mrss/" medium="image" type="image/jpeg" url="https://macmagazine.com.br/wp-content/uploads/2021/05/07-whatsapp-2-1260x840.jpg" width="1200" height="800" />
</item>
<item>
    <title>Como abrir todos os sites de uma pasta do favoritos do Safari [iPhone, iPad e Mac]</title>
    <link>https://macmagazine.com.br/post/2021/12/16/como-abrir-todos-os-sites-de-uma-pasta-do-favoritos-do-safari-iphone-ipad-e-mac/</link>
    <comments>https://macmagazine.com.br/post/2021/12/16/como-abrir-todos-os-sites-de-uma-pasta-do-favoritos-do-safari-iphone-ipad-e-mac/#respond</comments>
    <dc:creator>
        <![CDATA[Pedro Henrique Nunes]]>
    </dc:creator>
    <pubDate>Thu, 16 Dec 2021 10:15:00 +0000</pubDate>
    <category>
        <![CDATA[Apple]]>
    </category>
    <category>
        <![CDATA[Dicas]]>
    </category>
    <category>
        <![CDATA[Internet]]>
    </category>
    <category>
        <![CDATA[Mac]]>
    </category>
    <category>
        <![CDATA[Tutoriais]]>
    </category>
    <category>
        <![CDATA[Abas]]>
    </category>
    <category>
        <![CDATA[dica]]>
    </category>
    <category>
        <![CDATA[favoritos]]>
    </category>
    <category>
        <![CDATA[iOS]]>
    </category>
    <category>
        <![CDATA[iPad]]>
    </category>
    <category>
        <![CDATA[iPadOS]]>
    </category>
    <category>
        <![CDATA[iPhone]]>
    </category>
    <category>
        <![CDATA[macOS]]>
    </category>
    <category>
        <![CDATA[navegador]]>
    </category>
    <category>
        <![CDATA[pastas de favoritos]]>
    </category>
    <category>
        <![CDATA[Safari]]>
    </category>
    <category>
        <![CDATA[tutorial]]>
    </category>
    <guid isPermaLink="false">https://macmagazine.com.br/?p=841420</guid>
    <description>
        <![CDATA[O Safari muito provavelmente é o navegador mais usado por usuários de iPhones/iPads e Macs. Afinal de contas,&#8230;]]>
    </description>
    <content:encoded>
        <![CDATA[<img width="1200" height="526" src="https://macmagazine.com.br/wp-content/uploads/2021/02/23-safari-1260x552.png" class="webfeedsFeaturedVisual wp-post-image" alt="Safari" style="display: block; margin: auto; margin-bottom: 5px;max-width: 100%;" link_thumbnail="" srcset="https://macmagazine.com.br/wp-content/uploads/2021/02/23-safari-1260x552.png 1260w, https://macmagazine.com.br/wp-content/uploads/2021/02/23-safari-600x263.png 600w, https://macmagazine.com.br/wp-content/uploads/2021/02/23-safari-300x131.png 300w, https://macmagazine.com.br/wp-content/uploads/2021/02/23-safari-1536x673.png 1536w, https://macmagazine.com.br/wp-content/uploads/2021/02/23-safari-2048x897.png 2048w, https://macmagazine.com.br/wp-content/uploads/2021/02/23-safari-380x166.png 380w, https://macmagazine.com.br/wp-content/uploads/2021/02/23-safari-800x350.png 800w, https://macmagazine.com.br/wp-content/uploads/2021/02/23-safari-1160x508.png 1160w, https://macmagazine.com.br/wp-content/uploads/2021/02/23-safari.png 2743w" sizes="(max-width: 1200px) 100vw, 1200px" /><p>O <strong>Safari</strong> muito provavelmente é o navegador mais usado por usuários de iPhones/iPads e Macs.</p><p>Afinal de contas, por ele já vir incluído por padrão nos sistemas operacionais da Maçã, não é preciso baixar outro — a não ser que você precise ou <a href="https://macmagazine.com.br/post/2020/12/24/como-alterar-cliente-de-email-e-navegador-padroes-no-ios-14/">prefira outra opção, é claro</a>.</p><div class="wp-block-group posts-relacionados"><div class="wp-block-group__inner-container"><p><b>Posts relacionados</b></p><ul><li><a href="https://macmagazine.com.br/post/2021/01/07/como-adicionar-varias-abas-aos-favoritos-do-safari-em-iphones-e-ipads/">Como adicionar várias abas aos Favoritos do Safari em iPhones e iPads</a></li><li><a href="https://macmagazine.com.br/post/2021/10/02/como-criar-um-grupo-de-abas-no-safari-iphone-ipad-e-mac/">Como criar um Grupo de Abas no Safari [iPhone, iPad e Mac]</a></li><li><a href="https://macmagazine.com.br/post/2021/04/08/como-reabrir-todas-as-abas-da-ultima-sessao-do-safari-de-uma-vez-so-mac/">Como reabrir todas as abas da última sessão do Safari de uma vez só [Mac]</a></li></ul></div></div><p>Para manter os sites que você visita frequentemente — ou aqueles que você quer realmente guardar — organizados, a maneira mais fácil é criar pastas de favoritos, que você pode dividir em categorias como &#8220;Notícias&#8221; e &#8220;Entretenimento&#8221;, para dar alguns poucos exemplos.</p><p>Pois uma opção no Safari permite que você abra, de uma só vez, todos esses sites contidos em uma pasta dos favoritos. Isso é possível não só nos iPhones/iPads, como nos Macs também.</p><h2>Como abrir todos os sites de uma pasta de favoritos no iPhone/iPad</h2><p>Abra o Safari e toque no ícone representado por um livro (no iPhone, ele fica na parte inferior). Em seguida, toque na aba com o mesmo ícone aparente para ver todos os seus favoritos.</p><p>Após localizar a pasta onde os sites que você deseja abrir estão localizados, toque e segure o dedo sobre ela e selecione &#8220;Abrir em Novas Abas&#8221;.</p><div class="wp-block-image"><figure class="aligncenter size-large"><a href="https://macmagazine.com.br/wp-content/uploads/2021/12/15-abrir-abas-favoritos-Safari.png"><img width="1260" height="612" src="https://macmagazine.com.br/wp-content/uploads/2021/12/15-abrir-abas-favoritos-Safari-1260x612.png" alt="" class="wp-image-841435" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/15-abrir-abas-favoritos-Safari-1260x612.png 1260w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-abrir-abas-favoritos-Safari-600x291.png 600w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-abrir-abas-favoritos-Safari-300x146.png 300w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-abrir-abas-favoritos-Safari-1536x745.png 1536w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-abrir-abas-favoritos-Safari-2048x994.png 2048w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-abrir-abas-favoritos-Safari-380x184.png 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-abrir-abas-favoritos-Safari-800x388.png 800w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-abrir-abas-favoritos-Safari-1160x563.png 1160w" sizes="(max-width: 1260px) 100vw, 1260px" /></a></figure></div><p>Com isso, todas elas serão abertas separadamente em novas abas do navegador.</p><h2><meta charset="utf-8">Como abrir todos os sites de uma pasta de favoritos no Mac</h2><p><meta charset="utf-8">Abra o Safari no Mac e clique no botão localizado no canto superior esquerdo, para mostrar a barra lateral, e clique em &#8220;Favoritos&#8221;. Você também pode chegar a essa mesma seção usando o atalho <kbd>⌃</kbd><kbd>⌘</kbd><kbd>1</kbd>.</p><div class="wp-block-image"><figure class="aligncenter size-full"><a href="https://macmagazine.com.br/wp-content/uploads/2021/12/15-abrir-abas-favoritos-safari-mac.png"><img width="1132" height="940" src="https://macmagazine.com.br/wp-content/uploads/2021/12/15-abrir-abas-favoritos-safari-mac.png" alt="Abrir todos os sites de uma pasta de favoritos ao mesmo tempo" class="wp-image-841665" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/15-abrir-abas-favoritos-safari-mac.png 1132w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-abrir-abas-favoritos-safari-mac-600x498.png 600w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-abrir-abas-favoritos-safari-mac-300x249.png 300w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-abrir-abas-favoritos-safari-mac-380x316.png 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-abrir-abas-favoritos-safari-mac-800x664.png 800w" sizes="(max-width: 1132px) 100vw, 1132px" /></a></figure></div><p>Após localizar a pasta de favoritos, clique com o botão direito do mouse sobre ela e selecione &#8220;Abrir em Novas Abas&#8221;.</p><hr class="wp-block-separator is-style-dots"/><p>O que achou dessa dica? <img src="https://s.w.org/images/core/emoji/13.1.0/72x72/1f601.png" alt="😁" class="wp-smiley" style="height: 1em; max-height: 1em;" /></p>
]]>
</content:encoded>
<wfw:commentRss>https://macmagazine.com.br/post/2021/12/16/como-abrir-todos-os-sites-de-uma-pasta-do-favoritos-do-safari-iphone-ipad-e-mac/feed/</wfw:commentRss>
<slash:comments>0</slash:comments>
<post-id xmlns="com-wordpress:feed-additions:1">841420</post-id>
<media:content xmlns:media="http://search.yahoo.com/mrss/" medium="image" type="image/jpeg" url="https://macmagazine.com.br/wp-content/uploads/2021/02/23-safari-1260x552.png" width="1200" height="526" />
</item>
<item>
    <title>Como saber se uma foto foi capturada no modo Noite [iPhone e iPad]</title>
    <link>https://macmagazine.com.br/post/2021/12/16/como-saber-se-uma-foto-foi-capturada-no-modo-noite-iphone-e-ipad/</link>
    <comments>https://macmagazine.com.br/post/2021/12/16/como-saber-se-uma-foto-foi-capturada-no-modo-noite-iphone-e-ipad/#respond</comments>
    <dc:creator>
        <![CDATA[Pedro Henrique Nunes]]>
    </dc:creator>
    <pubDate>Thu, 16 Dec 2021 09:50:00 +0000</pubDate>
    <category>
        <![CDATA[Apple]]>
    </category>
    <category>
        <![CDATA[Dicas]]>
    </category>
    <category>
        <![CDATA[Telefonia]]>
    </category>
    <category>
        <![CDATA[Tutoriais]]>
    </category>
    <category>
        <![CDATA[captura]]>
    </category>
    <category>
        <![CDATA[dica]]>
    </category>
    <category>
        <![CDATA[fotografia]]>
    </category>
    <category>
        <![CDATA[fotos]]>
    </category>
    <category>
        <![CDATA[iOS 15.2]]>
    </category>
    <category>
        <![CDATA[iPadOS 15.2]]>
    </category>
    <category>
        <![CDATA[iPhone 11]]>
    </category>
    <category>
        <![CDATA[iPhone 12]]>
    </category>
    <category>
        <![CDATA[iPhone 13]]>
    </category>
    <category>
        <![CDATA[Modo Noite]]>
    </category>
    <category>
        <![CDATA[Night Mode]]>
    </category>
    <category>
        <![CDATA[tutorial]]>
    </category>
    <guid isPermaLink="false">https://macmagazine.com.br/?p=841383</guid>
    <description>
        <![CDATA[Desde o lançamento dos iPhones 11, a Apple oferece um recurso que há anos estava presente nos smartphones&#8230;]]>
    </description>
    <content:encoded>
        <![CDATA[<img width="1200" height="900" src="https://macmagazine.com.br/wp-content/uploads/2020/10/Apple_iphone12pro-camera-demo-nightmode_10132020-1260x945.jpg" class="webfeedsFeaturedVisual wp-post-image" alt="Demo de foto com modo Noite no iPhone 12 Pro" style="display: block; margin: auto; margin-bottom: 5px;max-width: 100%;" link_thumbnail="" srcset="https://macmagazine.com.br/wp-content/uploads/2020/10/Apple_iphone12pro-camera-demo-nightmode_10132020-1260x945.jpg 1260w, https://macmagazine.com.br/wp-content/uploads/2020/10/Apple_iphone12pro-camera-demo-nightmode_10132020-600x450.jpg 600w, https://macmagazine.com.br/wp-content/uploads/2020/10/Apple_iphone12pro-camera-demo-nightmode_10132020-300x225.jpg 300w, https://macmagazine.com.br/wp-content/uploads/2020/10/Apple_iphone12pro-camera-demo-nightmode_10132020-1536x1152.jpg 1536w, https://macmagazine.com.br/wp-content/uploads/2020/10/Apple_iphone12pro-camera-demo-nightmode_10132020.jpg 1960w" sizes="(max-width: 1200px) 100vw, 1200px" /><p>Desde o lançamento dos iPhones 11, a Apple oferece um recurso que há anos estava presente nos smartphones da concorrência: a possibilidade de capturar fotos no <strong><a href="https://macmagazine.com.br/post/2021/02/04/o-que-e-e-como-funciona-o-modo-noite-nos-iphones/">modo Noite (<em>Night mode</em>)</a></strong>. </p><p>Isso acaba possibilitando que você capture imagens com pouca luz com um resultado bastante satisfatório, visualizando ainda mais detalhes da cena. </p><div class="cnvs-block-posts cnvs-block-posts-1639575594802 cnvs-block-posts-layout-horizontal-type-1" data-layout="horizontal-type-1" data-min-height=""><div class="cs-posts-area" data-posts-area=""><div class="cs-posts-area__outer"><div class="cs-posts-area__main cs-block-posts-layout-horizontal-type-1 cs-display-column cs-posts-area__image-width-half"><article class="post-762685 post type-post status-publish format-standard has-post-thumbnail category-apple category-dicas category-software category-telefonia category-tutoriais tag-camera tag-estabilizacao tag-foto tag-iphone-11 tag-iphone-11-pro tag-iphone-11-pro-max tag-iphone-12 tag-iphone-12-mini tag-iphone-12-pro tag-iphone-12-pro-max tag-modo-noite tag-modo-retrato tag-night-mode tag-noite tag-retrato tag-selfie tag-sensor tag-time-lapse tag-tripe cs-entry cs-video-wrap"><div class="cs-entry__outer"><div class="cs-entry__inner cs-entry__thumbnail cs-entry__overlay cs-overlay-ratio cs-ratio-landscape-16-9"><div class="cs-overlay-background cs-overlay-transparent"><img width="2560" height="1920" src="https://macmagazine.com.br/wp-content/uploads/2020/03/03-concurso-modo-noite-scaled.jpg" class="attachment-medium_large size-medium_large wp-post-image" alt="Concurso de fotografia da Apple - Modo Noite" srcset="https://macmagazine.com.br/wp-content/uploads/2020/03/03-concurso-modo-noite-scaled.jpg 2560w, https://macmagazine.com.br/wp-content/uploads/2020/03/03-concurso-modo-noite-600x450.jpg 600w, https://macmagazine.com.br/wp-content/uploads/2020/03/03-concurso-modo-noite-1260x945.jpg 1260w, https://macmagazine.com.br/wp-content/uploads/2020/03/03-concurso-modo-noite-300x225.jpg 300w, https://macmagazine.com.br/wp-content/uploads/2020/03/03-concurso-modo-noite-1536x1152.jpg 1536w, https://macmagazine.com.br/wp-content/uploads/2020/03/03-concurso-modo-noite-2048x1536.jpg 2048w" sizes="(max-width: 2560px) 100vw, 2560px" />
                                    </div><a class="cs-overlay-link" href="https://macmagazine.com.br/post/2021/02/04/o-que-e-e-como-funciona-o-modo-noite-nos-iphones/"></a></div><div class="cs-entry__inner cs-entry__content"><h2 class="cs-entry__title "><a href="https://macmagazine.com.br/post/2021/02/04/o-que-e-e-como-funciona-o-modo-noite-nos-iphones/">O que é e como funciona o modo Noite nos iPhones?</a></h2><div class="cs-entry__post-meta" ><div class="cs-meta-author"><a class="cs-meta-author-inner url fn n" href="https://macmagazine.com.br/post/author/pedro/" title="View all posts by Pedro Henrique Nunes"><span class="cs-by">por</span><span class="cs-author">Pedro Henrique Nunes</span></a></div><div class="cs-meta-date">04/02/2021 • 08:15</div></div>        </div>
    </div></article>
                </div>
            </div>

                    </div>
    </div><p>Pois, a partir do <a href="https://macmagazine.com.br/post/2021/12/13/apple-lanca-ios-15-2-e-ipados-15-2-para-todos-os-usuarios/">iOS/iPadOS 15.2</a>, a Apple passou a indicar quando uma foto foi tirada usando essa configuração, o que pode ser bastante útil para muita gente.</p><p>Veja só como é fácil conferir essa informação: abra o Fotos (<em>Photos</em>) e escolha a imagem que deseja fazer a verificação. Em seguida, deslize o dedo de baixo para cima a partir dela para visualizar as informações da captura (ou toque no &#8220;i&#8221;).</p><div class="wp-block-image"><figure class="aligncenter size-large is-resized"><a href="https://macmagazine.com.br/wp-content/uploads/2021/12/15-foto-modo-noite-icone.png"><img src="https://macmagazine.com.br/wp-content/uploads/2021/12/15-foto-modo-noite-icone-638x1260.png" alt="" class="wp-image-841392" width="319" height="630" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/15-foto-modo-noite-icone-638x1260.png 638w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-foto-modo-noite-icone-304x600.png 304w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-foto-modo-noite-icone-152x300.png 152w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-foto-modo-noite-icone-778x1536.png 778w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-foto-modo-noite-icone-1037x2048.png 1037w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-foto-modo-noite-icone-380x750.png 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-foto-modo-noite-icone-800x1579.png 800w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-foto-modo-noite-icone-1160x2290.png 1160w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-foto-modo-noite-icone.png 1325w" sizes="(max-width: 319px) 100vw, 319px" /></a></figure></div><p>Caso a foto tenha sido tirada usando o modo Noite, você verá um ícone representado por uma lua ao lado direito, junto ao tempo de exposição da captura.</p><p>Legal, né?! <img src="https://s.w.org/images/core/emoji/13.1.0/72x72/1f30c.png" alt="🌌" class="wp-smiley" style="height: 1em; max-height: 1em;" /></p><p><span class="credito">via <a href="https://9to5mac.com/2021/12/14/ios-15-2-changes-features-whats-new-video/">9to5Mac</a></span></p>
]]>
</content:encoded>
<wfw:commentRss>https://macmagazine.com.br/post/2021/12/16/como-saber-se-uma-foto-foi-capturada-no-modo-noite-iphone-e-ipad/feed/</wfw:commentRss>
<slash:comments>0</slash:comments>
<post-id xmlns="com-wordpress:feed-additions:1">841383</post-id>
<media:content xmlns:media="http://search.yahoo.com/mrss/" medium="image" type="image/jpeg" url="https://macmagazine.com.br/wp-content/uploads/2020/10/Apple_iphone12pro-camera-demo-nightmode_10132020-1260x945.jpg" width="1200" height="900" />
</item>
<item>
    <title>Apple TV+ lança curta de Natal de &#8220;Ted Lasso&#8221; no YouTube</title>
    <link>https://macmagazine.com.br/post/2021/12/15/apple-tv-lanca-curta-de-natal-de-ted-lasso-no-youtube/</link>
    <comments>https://macmagazine.com.br/post/2021/12/15/apple-tv-lanca-curta-de-natal-de-ted-lasso-no-youtube/#respond</comments>
    <dc:creator>
        <![CDATA[Douglas Nascimento]]>
    </dc:creator>
    <pubDate>Thu, 16 Dec 2021 00:07:55 +0000</pubDate>
    <category>
        <![CDATA[Apple]]>
    </category>
    <category>
        <![CDATA[Destaques]]>
    </category>
    <category>
        <![CDATA[Vídeos]]>
    </category>
    <category>
        <![CDATA[Apple TV]]>
    </category>
    <category>
        <![CDATA[Apple TV+]]>
    </category>
    <category>
        <![CDATA[curta-metragem]]>
    </category>
    <category>
        <![CDATA[Jason Sudeikis]]>
    </category>
    <category>
        <![CDATA[Natal]]>
    </category>
    <category>
        <![CDATA[seriado]]>
    </category>
    <category>
        <![CDATA[Série]]>
    </category>
    <category>
        <![CDATA[Ted Lasso]]>
    </category>
    <category>
        <![CDATA[Ted Lasso — The Missing Christmas Mustache]]>
    </category>
    <category>
        <![CDATA[TV]]>
    </category>
    <category>
        <![CDATA[vídeo]]>
    </category>
    <guid isPermaLink="false">https://macmagazine.com.br/?p=841609</guid>
    <description>
        <![CDATA[Tendo a série &#8220;Ted Lasso&#8221; como um dos carros-chefe do seu catálogo, o Apple TV+ deu um presente&#8230;]]>
    </description>
    <content:encoded>
        <![CDATA[<img width="1200" height="675" src="https://macmagazine.com.br/wp-content/uploads/2021/12/15-ted-lasso-1260x709.jpg" class="webfeedsFeaturedVisual wp-post-image" alt="&quot;Ted Lasso — The Missing Christmas Mustache&quot;" style="display: block; margin: auto; margin-bottom: 5px;max-width: 100%;" link_thumbnail="" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/15-ted-lasso-1260x709.jpg 1260w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-ted-lasso-600x338.jpg 600w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-ted-lasso-300x169.jpg 300w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-ted-lasso-380x214.jpg 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-ted-lasso-800x450.jpg 800w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-ted-lasso-1160x653.jpg 1160w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-ted-lasso.jpg 1280w" sizes="(max-width: 1200px) 100vw, 1200px" /><p>Tendo a série <strong><a href="https://tv.apple.com/br/show/ted-lasso/umc.cmc.vtoh0mn0xn7t3c643xqonfzy?at=10lt3B">&#8220;Ted Lasso&#8221;</a></strong> como um dos carros-chefe do seu catálogo, o <strong>Apple TV+</strong> deu um presente de Natal para lá de especial para quem curte a produção estrelada por<strong>Jason Sudeikis</strong>.</p><p>Trata-se de um curta-metragem animado lançado no canal oficial da plataforma no YouTube, contando com as vozes dos personagens da série premiada. </p><p>No curta, intitulado <strong><a href="https://www.apple.com/tv-pr/news/2021/12/apples-emmy-award-winning-hit-comedy-ted-lasso-adds-joy-to-the-season-with-animated-holiday-short/"><em>&#8220;Ted Lasso — The Missing Christmas Mustache&#8221;</em></a></strong> (algo como &#8220;Ted Lasso — O Bigode de Natal Desaparecido&#8221;), o treinador do AFC Richmond perde o seu bigode um pouco antes de fazer um <a href="https://apps.apple.com/br/app/facetime/id1110145091">FaceTime</a> de Natal com seu filho — o que deixa o protagonista num tremendo desespero.</p><p>Com isso, o personagem de Sudeikis contará com a ajuda de seus amigos para procurar o item perdido, o que o levará a descobrir o real significado do Natal.</p><figure class="wp-block-embed aligncenter is-type-video is-provider-youtube wp-block-embed-youtube wp-embed-aspect-16-9 wp-has-aspect-ratio"><div class="wp-block-embed__wrapper"><iframe loading="lazy" title="Ted Lasso — The Missing Christmas Mustache | Apple TV+" width="1200" height="675" src="https://www.youtube.com/embed/UW_qXIHtmTk?feature=oembed" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div></figure><p>&#8220;Ted Lasso&#8221;, vale recordar, já teve duas temporadas lançadas e é um sucesso inquestionável, aclamada tanto pelo público quanto pela crítica (com <a href="https://macmagazine.com.br/post/2021/09/15/ted-lasso-leva-3-premios-dos-criticos-dos-eua-incluindo-serie-do-ano/">vários prêmios e indicações</a>). A terceira temporada<a href="https://macmagazine.com.br/post/2020/10/28/apple-confirma-3a-temporada-de-ted-lasso-e-exalta-sucesso-da-serie/">já foi confirmada</a>, é claro.</p><p>O Apple TV+ está disponível no app Apple TV em mais de 100 países e regiões, seja em iPhones, iPads, Apple TVs, Macs, smart TVs ou online — além também estar em aparelhos como Roku, Amazon Fire TV, Chromecast com Google TV, consoles PlayStation e Xbox. O serviço <a href="https://apple.co/2Z6v2i4">custa <strong>R$9,90 por mês</strong></a>, com um período de teste gratuito de sete dias. Por tempo limitado, quem comprar e ativar um novo iPhone, iPad, Apple TV, Mac ou iPod touch ganha três meses de Apple TV+. Ele também faz parte do pacote de assinaturas da empresa, o <a href="https://macmagazine.com.br/post/2020/10/30/apple-one-esta-agora-disponivel-veja-como-assinar/">Apple One</a>.</p><hr /><div class="appbox"><div class="appbox-icon"><a href="https://apps.apple.com/br/app/apple-tv/id1174078549" target="_blank"><img class="appbox-iconiOS" alt="&Iacute;cone do app Apple TV" src="https://is5-ssl.mzstatic.com/image/thumb/Purple116/v4/42/6e/37/426e37bf-dcbd-79a1-2927-cd7889239dad/AppIcon-0-0-1x_U007emarketing-0-0-0-7-0-0-sRGB-0-0-0-GLES2_U002c0-512MB-85-220-0-0.png/256x256bb.png" /></a></div><div class="appbox-details"><span class="appbox-name"><a href="https://apps.apple.com/br/app/apple-tv/id1174078549" target="_blank">Apple TV</a></span><span class="appbox-de">de <strong><a href="https://www.apple.com/br/apple-tv-app/" target="_blank" class="no_icon" rel="nofollow">Apple</a></strong></span><div class="appbox-devices"><img src="https://macmagazine.com.br/wp-content/uploads/2015/11/devices_ipad.png" alt="Compat&iacute;vel com iPads" title="Compat&iacute;vel com iPads" class="appbox-devicesiPad" /><img src="https://macmagazine.com.br/wp-content/uploads/2015/11/devices_iphone.png" alt="Compat&iacute;vel com iPhones" title="Compat&iacute;vel com iPhones" class="appbox-devicesiPhone" /></div><div class="appbox-info">Vers&atilde;o <strong>1.7</strong> (888.8 KB)<br />
                    Requer o <strong>iOS 10.2</strong> ou superior</div></div><div class="appbox-badge"><span class="appbox-price">Gr&aacute;tis</span><span><a href="https://apps.apple.com/br/app/apple-tv/id1174078549" target="_blank"><img alt="Badge - Baixar na App Store" src="https://macmagazine.com.br/wp-content/uploads/2017/11/22-badge_appstore.png" class="badgeInvert" /></a></span><span class="appbox-QRcode"><a href="javascript:void(0);" title="C&oacute;digo QR - Apple TV" onclick="javascript:abrirQR('https://chart.googleapis.com/chart?chs=400x400&cht=qr&chl=https%3A%2F%2Fapps.apple.com%2Fbr%2Fapp%2Fapple-tv%2Fid1174078549&chld=L|0');return false;"><img alt="C&oacute;digo QR" src="https://macmagazine.com.br/wp-content/themes/newsblock-child/images/qr.png" /></a><a href="javascript:void(0);" title="C&oacute;digo QR - Apple TV" onclick="javascript:abrirQR('https://chart.googleapis.com/chart?chs=400x400&cht=qr&chl=https%3A%2F%2Fapps.apple.com%2Fbr%2Fapp%2Fapple-tv%2Fid1174078549&chld=L|0');return false;">C&oacute;digo QR</a></span></div>
                </div>
]]>
</content:encoded>
<wfw:commentRss>https://macmagazine.com.br/post/2021/12/15/apple-tv-lanca-curta-de-natal-de-ted-lasso-no-youtube/feed/</wfw:commentRss>
<slash:comments>0</slash:comments>
<post-id xmlns="com-wordpress:feed-additions:1">841609</post-id>
<media:content xmlns:media="http://search.yahoo.com/mrss/" medium="image" type="image/jpeg" url="https://macmagazine.com.br/wp-content/uploads/2021/12/15-ted-lasso-1260x709.jpg" width="1200" height="675" />
</item>
<item>
    <title>Criador de &#8220;The Shrink Next Door&#8221; está processando a Bloomberg</title>
    <link>https://macmagazine.com.br/post/2021/12/15/criador-de-the-shrink-next-door-esta-processando-a-bloomberg/</link>
    <comments>https://macmagazine.com.br/post/2021/12/15/criador-de-the-shrink-next-door-esta-processando-a-bloomberg/#respond</comments>
    <dc:creator>
        <![CDATA[Diogo Ammon]]>
    </dc:creator>
    <pubDate>Wed, 15 Dec 2021 23:38:50 +0000</pubDate>
    <category>
        <![CDATA[Apple]]>
    </category>
    <category>
        <![CDATA[Dinheiro]]>
    </category>
    <category>
        <![CDATA[Projetos]]>
    </category>
    <category>
        <![CDATA[adaptação]]>
    </category>
    <category>
        <![CDATA[Apple TV+]]>
    </category>
    <category>
        <![CDATA[Bloomberg]]>
    </category>
    <category>
        <![CDATA[Bloomberg Media]]>
    </category>
    <category>
        <![CDATA[contrato]]>
    </category>
    <category>
        <![CDATA[criador]]>
    </category>
    <category>
        <![CDATA[direitos]]>
    </category>
    <category>
        <![CDATA[história]]>
    </category>
    <category>
        <![CDATA[Joe Nocera]]>
    </category>
    <category>
        <![CDATA[Jornalista]]>
    </category>
    <category>
        <![CDATA[MRC Studios]]>
    </category>
    <category>
        <![CDATA[o psiquiatra ao lado]]>
    </category>
    <category>
        <![CDATA[Podcast]]>
    </category>
    <category>
        <![CDATA[receita]]>
    </category>
    <category>
        <![CDATA[the shrink next door]]>
    </category>
    <category>
        <![CDATA[Washington Post]]>
    </category>
    <category>
        <![CDATA[Wondery]]>
    </category>
    <guid isPermaLink="false">https://macmagazine.com.br/?p=841552</guid>
    <description>
        <![CDATA[A minissérie &#8220;The Shrink Next Door&#8221; (&#8220;O Psiquiatra ao Lado&#8221;) chegou às telas do Apple TV+ em novembro&#8230;]]>
    </description>
    <content:encoded>
        <![CDATA[<img width="1200" height="675" src="https://macmagazine.com.br/wp-content/uploads/2021/10/12-The_Shrink_Next_Door-1260x709.jpg" class="webfeedsFeaturedVisual wp-post-image" alt="The Shrink Next Door" style="display: block; margin: auto; margin-bottom: 5px;max-width: 100%;" link_thumbnail="" srcset="https://macmagazine.com.br/wp-content/uploads/2021/10/12-The_Shrink_Next_Door-1260x709.jpg 1260w, https://macmagazine.com.br/wp-content/uploads/2021/10/12-The_Shrink_Next_Door-600x338.jpg 600w, https://macmagazine.com.br/wp-content/uploads/2021/10/12-The_Shrink_Next_Door-300x169.jpg 300w, https://macmagazine.com.br/wp-content/uploads/2021/10/12-The_Shrink_Next_Door-1536x864.jpg 1536w, https://macmagazine.com.br/wp-content/uploads/2021/10/12-The_Shrink_Next_Door-2048x1152.jpg 2048w, https://macmagazine.com.br/wp-content/uploads/2021/10/12-The_Shrink_Next_Door-380x214.jpg 380w, https://macmagazine.com.br/wp-content/uploads/2021/10/12-The_Shrink_Next_Door-800x450.jpg 800w, https://macmagazine.com.br/wp-content/uploads/2021/10/12-The_Shrink_Next_Door-1160x653.jpg 1160w, https://macmagazine.com.br/wp-content/uploads/2021/10/12-The_Shrink_Next_Door.jpg 3840w" sizes="(max-width: 1200px) 100vw, 1200px" /><p>A minissérie <strong><a href="https://tv.apple.com/br/show/o-psiquiatra-ao-lado/umc.cmc.jov1gljmqnux0i15rbqsoyfk?at=10lt3B"><em>&#8220;The Shrink Next Door&#8221;</em></a> (&#8220;O Psiquiatra ao Lado&#8221;)</strong> chegou às telas do <strong>Apple TV+</strong><a href="https://macmagazine.com.br/post/2021/11/12/estreias-do-dia-no-apple-tv-o-psiquiatra-ao-lado-e-snoopy-no-espaco/">em novembro passado</a>, e gira em torno da relação complicada entre um psiquiatra (interpretado por<strong>Paul Rudd</strong>) e um de seus pacientes (vivido por<strong>Will Ferrell</strong>).</p><p>A Apple <a href="https://macmagazine.com.br/post/2020/04/25/apple-tv-tera-minisserie-de-comedia-com-will-ferrell-e-paul-rudd-experiencia-visual-do-novo-album-do-pearl-jam-esta-disponivel/">adquiriu os direito da comédia</a> em abril de 2020. Na época, ela fazia sucesso como um podcast da<strong>Wondery</strong>, contando a história da série — a qual, vale notar, é baseada em fatos reais que ocorreram com conhecidos do criador do podcast,<strong>Joe Nocera</strong> — que trabalhava para a<strong><em>Bloomberg News</em></strong>.</p><p>Agora, segundo <a href="https://www.washingtonpost.com/media/2021/12/14/shrink-next-door-joe-nocera-sues-bloomberg/">uma reportagem do <em>Washington Post</em></a>, Nocera está processando seu ex-empregador, a Bloomberg Media, por quebra de contrato — argumentando que a empresa de mídia deve a ele lucros relativos à adaptação da Apple.</p><p>Nocera se juntou à Wondery quando ainda era colunista da <em>Bloomberg</em> para transformar uma de suas histórias não publicadas em um podcast. Na época,<em>Bloomberg</em> e Wondery tinham uma parceria na qual colaborariam em podcasts — um dos resultados foi a história de Marty Markowitz (Ferrell) e seu terapeuta Isaac &#8220;Ike&#8221; Herschkopf (Rudd).</p><p>Com o sucesso, os direitos do podcast foram adquiridos pela <strong>MRC Studios</strong>, com a Wondery e a<em>Bloomberg</em> dividindo as receitas geradas por meio de um acordo com a MRC. O processo declara que<em>Bloomberg</em> e Nocera também haviam firmado um acordo entre si, no qual ambos dividiram igualmente as receitas que a empresa obtivesse da exploração do podcast por terceiros não afiliados à<em>Bloomberg</em> — um deles, claro, a Apple.</p><p>Nocera esperava receber metade do valor da opção inicial para a série (US$125 mil), mas a <em>Bloomberg</em> disse que ele não teria direito a nenhuma receita de publicidade da série, citando a posição da empresa de que os jornalistas não tinham direito aos lucros com propaganda. Nocera, por sua vez, argumenta que isso viola a parte do contrato a qual diz que eles dividiriam todas as receitas geradas &#8220;por terceiros não afiliados à<em>Bloomberg</em>&#8220;.</p><p>Por outro lado, a <em>Bloomberg</em> reconhece que a MRC devia a Nocera cerca de US$322 mil, mas que a maior parte desse dinheiro já foi paga, faltando cerca de US$35 mil. Nocera, entretanto, argumenta que o valor a ser recebido por ele deveria ser muito maior.<a href="https://www.thewrap.com/shrink-next-door-lawsuit-bloomberg-profits-apple-tv-plus/">Ao <em>The Wrap</em></a>, um porta-voz da <em>Bloomberg News</em> disse que a empresa continuaria a honrar todas as suas obrigações contratuais com o jornalista.</p><p>O <a href="https://www.washingtonpost.com/media/2021/12/14/shrink-next-door-joe-nocera-sues-bloomberg/">artigo do <em>Washington Post</em></a> ainda detalha outras polêmicas envolvendo Nocera, uma das quais levou à sua demissão da <em>Bloomberg</em>. De qualquer forma, ainda não há como saber quem está certo nessa história.</p>
]]>
</content:encoded>
<wfw:commentRss>https://macmagazine.com.br/post/2021/12/15/criador-de-the-shrink-next-door-esta-processando-a-bloomberg/feed/</wfw:commentRss>
<slash:comments>0</slash:comments>
<post-id xmlns="com-wordpress:feed-additions:1">841552</post-id>
<media:content xmlns:media="http://search.yahoo.com/mrss/" medium="image" type="image/jpeg" url="https://macmagazine.com.br/wp-content/uploads/2021/10/12-The_Shrink_Next_Door-1260x709.jpg" width="1200" height="675" />
</item>
<item>
    <title>Apple adia retorno presencial por tempo indeterminado (sim, de novo)</title>
    <link>https://macmagazine.com.br/post/2021/12/15/apple-adia-retorno-presencial-por-tempo-indeterminado-sim-de-novo/</link>
    <comments>https://macmagazine.com.br/post/2021/12/15/apple-adia-retorno-presencial-por-tempo-indeterminado-sim-de-novo/#respond</comments>
    <dc:creator>
        <![CDATA[Douglas Nascimento]]>
    </dc:creator>
    <pubDate>Wed, 15 Dec 2021 23:01:20 +0000</pubDate>
    <category>
        <![CDATA[Apple]]>
    </category>
    <category>
        <![CDATA[Destaques]]>
    </category>
    <category>
        <![CDATA[Dinheiro]]>
    </category>
    <category>
        <![CDATA[Apple Inc]]>
    </category>
    <category>
        <![CDATA[Apple Park]]>
    </category>
    <category>
        <![CDATA[Corporação]]>
    </category>
    <category>
        <![CDATA[COVID-19]]>
    </category>
    <category>
        <![CDATA[empregados]]>
    </category>
    <category>
        <![CDATA[escritórios]]>
    </category>
    <category>
        <![CDATA[funcionários]]>
    </category>
    <category>
        <![CDATA[Mark Gurman]]>
    </category>
    <category>
        <![CDATA[Omicron]]>
    </category>
    <category>
        <![CDATA[pandemia]]>
    </category>
    <category>
        <![CDATA[retorno dos funcionários]]>
    </category>
    <category>
        <![CDATA[Saúde]]>
    </category>
    <category>
        <![CDATA[Tim Cook]]>
    </category>
    <guid isPermaLink="false">https://macmagazine.com.br/?p=841570</guid>
    <description>
        <![CDATA[Com a disseminação de novas variantes da COVID-19 e o surgimento de surtos do vírus entre funcionários, a&#8230;]]>
    </description>
    <content:encoded>
        <![CDATA[<img width="1200" height="800" src="https://macmagazine.com.br/wp-content/uploads/2021/12/09-Apple-Park-Wallpaper-12-1260x840.jpg" class="webfeedsFeaturedVisual wp-post-image" alt="Apple Park na Wallpaper*" style="display: block; margin: auto; margin-bottom: 5px;max-width: 100%;" link_thumbnail="" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/09-Apple-Park-Wallpaper-12-1260x840.jpg 1260w, https://macmagazine.com.br/wp-content/uploads/2021/12/09-Apple-Park-Wallpaper-12-600x400.jpg 600w, https://macmagazine.com.br/wp-content/uploads/2021/12/09-Apple-Park-Wallpaper-12-300x200.jpg 300w, https://macmagazine.com.br/wp-content/uploads/2021/12/09-Apple-Park-Wallpaper-12-380x253.jpg 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/09-Apple-Park-Wallpaper-12-800x533.jpg 800w, https://macmagazine.com.br/wp-content/uploads/2021/12/09-Apple-Park-Wallpaper-12-1160x773.jpg 1160w, https://macmagazine.com.br/wp-content/uploads/2021/12/09-Apple-Park-Wallpaper-12.jpg 1460w" sizes="(max-width: 1200px) 100vw, 1200px" /><p>Com a disseminação de novas variantes da COVID-19 e o surgimento de surtos do vírus entre funcionários, a Apple vem tomando decisões nada animadoras. Após <a href="https://macmagazine.com.br/post/2021/12/15/apple-fecha-3-lojas-de-uma-vez-apos-novos-surtos-de-covid-19/">fechar temporariamente três lojas físicas</a> de uma só vez, a empresa acaba de suspender o retorno presencial dos funcionários corporativos.</p><p>A informação foi dada pelo jornalista <strong>Mark Gurman</strong>,<a href="https://www.bloomberg.com/news/articles/2021-12-15/apple-delays-return-to-office-until-date-yet-to-be-determined">na <em>Bloomberg</em></a>. Segundo ele, o retorno das atividades corporativas em escritórios físicos, que estava programado para 1º de fevereiro, foi adiado para uma nova data &#8220;ainda não determinada&#8221; pela Apple, decisão que foi efetivada em memorando enviado hoje por <strong>Tim Cook</strong> aos funcionários.</p><figure class="wp-block-embed aligncenter is-type-rich is-provider-twitter wp-block-embed-twitter"><div class="wp-block-embed__wrapper"><blockquote class="twitter-tweet" data-width="550" data-dnt="true"><p lang="en" dir="ltr">Breaking on <a href="https://twitter.com/TheTerminal?ref_src=twsrc%5Etfw">@TheTerminal</a>: Apple delays corporate office return to “date yet to be determined.” Was supposed to be February 1.</p>&mdash; Mark Gurman (@markgurman) <a href="https://twitter.com/markgurman/status/1471237100255252484?ref_src=twsrc%5Etfw">December 15, 2021</a></blockquote><script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script></div></figure><p>O retorno das atividades presenciais é visto com expectativa como um dos últimos passos para a normalização total dos trabalhos da empresa. Agora, o mercado terá que esperar mais um pouco até que isso se concretize, principalmente após acontecimentos recentes não tão animadores.</p><p>O próprio Gurman, <a href="https://www.bloomberg.com/news/articles/2021-12-15/apple-temporarily-shuts-three-retail-stores-after-covid-19-surge">na matéria</a> que escreveu mais cedo na<em>Bloomberg</em> noticiando o fechamento das lojas da Apple nos EUA e no Canadá, aventou a possibilidade de o aumento dos casos de COVID-19 atrapalhar os planos da Maçã para o retorno dos funcionários corporativos.</p><p>Na publicação, ficou claro que os casos envolvendo o vírus vêm aumentando nos Estados Unidos, em boa parte por causa da variante Ômicron. Não é leviano concluir que a decisão da Apple sobre o retorno dos funcionários tem relação direta com esse aumento.</p><p>Fato é que a suspensão deverá animar os trabalhadores da empresa, que temiam o retorno aos escritórios físicos. <a href="https://macmagazine.com.br/post/2021/06/05/empregados-da-apple-reclamam-de-retorno-ao-trabalho-presencial/">Como publicamos em junho</a>, um grupo de ao menos 80 empregados não ficou nada satisfeito com a notícia de que teriam que retornar ao ambiente corporativo (na época, a expectativa ainda era de que isso acontecesse em setembro).</p>
]]>
</content:encoded>
<wfw:commentRss>https://macmagazine.com.br/post/2021/12/15/apple-adia-retorno-presencial-por-tempo-indeterminado-sim-de-novo/feed/</wfw:commentRss>
<slash:comments>0</slash:comments>
<post-id xmlns="com-wordpress:feed-additions:1">841570</post-id>
<media:content xmlns:media="http://search.yahoo.com/mrss/" medium="image" type="image/jpeg" url="https://macmagazine.com.br/wp-content/uploads/2021/12/09-Apple-Park-Wallpaper-12-1260x840.jpg" width="1200" height="800" />
</item>
<item>
    <title>Promoções na App Store: Rikudo Puzzles, Starlight, Total Video Player e mais!</title>
    <link>https://macmagazine.com.br/post/2021/12/15/promocoes-na-app-store-rikudo-puzzles-starlight-total-video-player-e-mais/</link>
    <comments>https://macmagazine.com.br/post/2021/12/15/promocoes-na-app-store-rikudo-puzzles-starlight-total-video-player-e-mais/#respond</comments>
    <dc:creator>
        <![CDATA[Marcelo Melo]]>
    </dc:creator>
    <pubDate>Wed, 15 Dec 2021 22:54:24 +0000</pubDate>
    <category>
        <![CDATA[Dicas]]>
    </category>
    <category>
        <![CDATA[Dinheiro]]>
    </category>
    <category>
        <![CDATA[Gadgets]]>
    </category>
    <category>
        <![CDATA[Jogos]]>
    </category>
    <category>
        <![CDATA[Mac]]>
    </category>
    <category>
        <![CDATA[Software]]>
    </category>
    <category>
        <![CDATA[aplicativos]]>
    </category>
    <category>
        <![CDATA[App Store]]>
    </category>
    <category>
        <![CDATA[apps]]>
    </category>
    <category>
        <![CDATA[ETA - Arrive on time]]>
    </category>
    <category>
        <![CDATA[Mac App Store]]>
    </category>
    <category>
        <![CDATA[Number Mazes: Rikudo Puzzles]]>
    </category>
    <category>
        <![CDATA[promoção]]>
    </category>
    <category>
        <![CDATA[Starlight: Mapa do Céu]]>
    </category>
    <category>
        <![CDATA[The Christmas List]]>
    </category>
    <category>
        <![CDATA[Total Video Player]]>
    </category>
    <guid isPermaLink="false">https://macmagazine.com.br/?p=841579</guid>
    <description>
        <![CDATA[Para esta quarta-feira, aproveite a nossa seleção de promoções na App Store! Rikudo é um jogo de lógica,&#8230;]]>
    </description>
    <content:encoded>
        <![CDATA[<img width="984" height="502" src="https://macmagazine.com.br/wp-content/uploads/2021/12/15-Rikudo.png" class="webfeedsFeaturedVisual wp-post-image" alt="Rikudo" style="display: block; margin: auto; margin-bottom: 5px;max-width: 100%;" link_thumbnail="" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/15-Rikudo.png 984w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-Rikudo-600x306.png 600w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-Rikudo-300x153.png 300w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-Rikudo-380x194.png 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-Rikudo-800x408.png 800w" sizes="(max-width: 984px) 100vw, 984px" /><p>Para esta quarta-feira, aproveite a nossa seleção de <strong>promoções na App Store</strong>!</p><p class="has-text-align-left wp-embed-aspect-16-9 wp-has-aspect-ratio"><strong>Rikudo</strong> é um jogo de lógica, desenvolvido por uma empresa homônima e nossa escolha para destaque do dia.</p><p>Seu objetivo é encontrar o caminho de número consecutivos em um favo de mel (hexagonal de células). São mais de 900 fases, algumas com dicas e um modo do mal para quem curte um desafio ainda maior.</p><hr /><div class="appbox"><div class="appbox-icon"><a href="https://apps.apple.com/br/app/number-mazes-rikudo-puzzles/id1073513516" target="_blank"><img class="appbox-iconiOS" alt="&Iacute;cone do app Number Mazes: Rikudo Puzzles" src="https://is5-ssl.mzstatic.com/image/thumb/Purple124/v4/37/a9/ed/37a9ed7b-32f6-81a5-a637-7e14f23058b9/AppIcon-0-1x_U007emarketing-0-85-220-7.png/256x256bb.png" /></a></div><div class="appbox-details"><span class="appbox-name"><a href="https://apps.apple.com/br/app/number-mazes-rikudo-puzzles/id1073513516" target="_blank">Number Mazes: Rikudo Puzzles</a></span><span class="appbox-de">de <strong><a href="" target="_blank" class="no_icon" rel="nofollow">Rikudo</a></strong></span><div class="appbox-devices"><img src="https://macmagazine.com.br/wp-content/uploads/2015/11/devices_ipad.png" alt="Compat&iacute;vel com iPads" title="Compat&iacute;vel com iPads" class="appbox-devicesiPad" /><img src="https://macmagazine.com.br/wp-content/uploads/2015/11/devices_iphone.png" alt="Compat&iacute;vel com iPhones" title="Compat&iacute;vel com iPhones" class="appbox-devicesiPhone" /></div><div class="appbox-info">Vers&atilde;o <strong>1.1</strong> (92.1 MB)<br />
                    Requer o <strong>iOS 8.0</strong> ou superior</div></div><div class="appbox-badge"><span class="appbox-price">Gr&aacute;tis <b class="appbox-oldprice">R$ 16.90</b></span><span><a href="https://apps.apple.com/br/app/number-mazes-rikudo-puzzles/id1073513516" target="_blank"><img alt="Badge - Baixar na App Store" src="https://macmagazine.com.br/wp-content/uploads/2017/11/22-badge_appstore.png" class="badgeInvert" /></a></span><span class="appbox-QRcode"><a href="javascript:void(0);" title="C&oacute;digo QR - Number Mazes: Rikudo Puzzles" onclick="javascript:abrirQR('https://chart.googleapis.com/chart?chs=400x400&cht=qr&chl=https%3A%2F%2Fapps.apple.com%2Fbr%2Fapp%2Fnumber-mazes-rikudo-puzzles%2Fid1073513516&chld=L|0');return false;"><img alt="C&oacute;digo QR" src="https://macmagazine.com.br/wp-content/themes/newsblock-child/images/qr.png" /></a><a href="javascript:void(0);" title="C&oacute;digo QR - Number Mazes: Rikudo Puzzles" onclick="javascript:abrirQR('https://chart.googleapis.com/chart?chs=400x400&cht=qr&chl=https%3A%2F%2Fapps.apple.com%2Fbr%2Fapp%2Fnumber-mazes-rikudo-puzzles%2Fid1073513516&chld=L|0');return false;">C&oacute;digo QR</a></span></div>
                </div><div class="appbox-screenshots"><img src="https://is1-ssl.mzstatic.com/image/thumb/Purple128/v4/b4/af/81/b4af816c-69ce-5bc7-45f5-ce39af9a0d16/pr_source.png/1242x2208bb.jpg" class="appbox-screenshotsIMG" alt="Screenshot do app Number Mazes: Rikudo Puzzles" style="width: 320px;" /><img src="https://is5-ssl.mzstatic.com/image/thumb/Purple118/v4/0d/e8/8f/0de88ff8-26cd-13c3-f0f5-dab6f4f7d92d/pr_source.png/1242x2208bb.jpg" class="appbox-screenshotsIMG" alt="Screenshot do app Number Mazes: Rikudo Puzzles" style="width: 320px;" /><img src="https://is4-ssl.mzstatic.com/image/thumb/Purple128/v4/31/31/8a/31318ade-1c08-bda1-e4d9-037c6f39aebd/pr_source.png/1242x2208bb.jpg" class="appbox-screenshotsIMG" alt="Screenshot do app Number Mazes: Rikudo Puzzles" style="width: 320px;" /><img src="https://is2-ssl.mzstatic.com/image/thumb/Purple118/v4/a0/ef/9e/a0ef9e32-28bb-fb7d-4536-a21b38023f11/pr_source.png/1242x2208bb.jpg" class="appbox-screenshotsIMG" alt="Screenshot do app Number Mazes: Rikudo Puzzles" style="width: 320px;" /><img src="https://is2-ssl.mzstatic.com/image/thumb/Purple128/v4/08/c6/72/08c67221-2452-37f2-f2b8-35a3ddf47ff8/pr_source.png/1242x2208bb.jpg" class="appbox-screenshotsIMG" alt="Screenshot do app Number Mazes: Rikudo Puzzles" style="width: 320px;" /><img src="https://is2-ssl.mzstatic.com/image/thumb/Purple118/v4/54/f2/c3/54f2c345-c3ab-7ddb-6507-950ed8410ac7/pr_source.png/1242x2208bb.jpg" class="appbox-screenshotsIMG" alt="Screenshot do app Number Mazes: Rikudo Puzzles" style="width: 320px;" /><img src="https://is5-ssl.mzstatic.com/image/thumb/Purple128/v4/38/bf/a0/38bfa0bf-8fca-cc6b-78f7-70aad89245ea/pr_source.png/1242x2208bb.jpg" class="appbox-screenshotsIMG" alt="Screenshot do app Number Mazes: Rikudo Puzzles" style="width: 320px;" /></div><div class="appbox-rating"><div class="appbox-ratingCell" style="border-right-width: 4px;"><strong>N/D</strong><br />Nota na App Store</div><div class="appbox-ratingCell" style="border-left-width: 4px;"><span class="estrela estrela-inteira"></span><span class="estrela estrela-inteira"></span><span class="estrela estrela-inteira"></span><span class="estrela estrela-inteira"></span><span class="estrela estrela-vazia"></span><br />Minha nota</div>
                    </div><blockquote class="wp-block-quote"><p>As regras são simples. Coloque um número em cada hexágono de forma que dois números consecutivos sejam vizinhos. No final, o encadeamento dos números consecutivos devem formar um caminho que passa por todos os hexágonos e por todos os diamantes que conectam alguns deles.</p></blockquote><p>Curtiu? Aproveite a oferta e boa diversão! <img src="https://s.w.org/images/core/emoji/13.1.0/72x72/1f600.png" alt="😀" class="wp-smiley" style="height: 1em; max-height: 1em;" /></p><hr class="wp-block-separator is-style-dots is-cnvs-separator-id-1618912657762"/><p>Abaixo outros aplicativos que, juntos, somam <strong>quase R$87 em descontos</strong>:</p><h2>Apps para iOS/iPadOS/watchOS</h2><hr /><div class="appbox"><div class="appbox-icon"><a href="https://apps.apple.com/br/app/starlight-mapa-do-c%C3%A9u/id762002305" target="_blank"><img class="appbox-iconiOS" alt="&Iacute;cone do app Starlight: Mapa do C&eacute;u" src="https://is4-ssl.mzstatic.com/image/thumb/Purple124/v4/c7/3d/3e/c73d3ec6-f00b-7ad2-9b5b-193683c87e80/AppIcon-0-0-1x_U007emarketing-0-0-0-7-0-0-sRGB-0-0-0-GLES2_U002c0-512MB-85-220-0-0.png/256x256bb.png" /></a></div><div class="appbox-details"><span class="appbox-name"><a href="https://apps.apple.com/br/app/starlight-mapa-do-c%C3%A9u/id762002305" target="_blank">Starlight: Mapa do Céu</a></span><span class="appbox-de">de <strong><a href="" target="_blank" class="no_icon" rel="nofollow">ION6, LLC</a></strong></span><div class="appbox-devices"><img src="https://macmagazine.com.br/wp-content/uploads/2015/11/devices_ipad.png" alt="Compat&iacute;vel com iPads" title="Compat&iacute;vel com iPads" class="appbox-devicesiPad" /><img src="https://macmagazine.com.br/wp-content/uploads/2015/11/devices_iphone.png" alt="Compat&iacute;vel com iPhones" title="Compat&iacute;vel com iPhones" class="appbox-devicesiPhone" /></div><div class="appbox-info">Vers&atilde;o <strong>3.2.6</strong> (72.1 MB)<br />
                    Requer o <strong>iOS 12.1</strong> ou superior</div></div><div class="appbox-badge"><span class="appbox-price">Gr&aacute;tis <b class="appbox-oldprice">R$ 10.90</b></span><span><a href="https://apps.apple.com/br/app/starlight-mapa-do-c%C3%A9u/id762002305" target="_blank"><img alt="Badge - Baixar na App Store" src="https://macmagazine.com.br/wp-content/uploads/2017/11/22-badge_appstore.png" class="badgeInvert" /></a></span><span class="appbox-QRcode"><a href="javascript:void(0);" title="C&oacute;digo QR - Starlight: Mapa do C&eacute;u" onclick="javascript:abrirQR('https://chart.googleapis.com/chart?chs=400x400&cht=qr&chl=https%3A%2F%2Fapps.apple.com%2Fbr%2Fapp%2Fstarlight-mapa-do-c%25C3%25A9u%2Fid762002305&chld=L|0');return false;"><img alt="C&oacute;digo QR" src="https://macmagazine.com.br/wp-content/themes/newsblock-child/images/qr.png" /></a><a href="javascript:void(0);" title="C&oacute;digo QR - Starlight: Mapa do C&eacute;u" onclick="javascript:abrirQR('https://chart.googleapis.com/chart?chs=400x400&cht=qr&chl=https%3A%2F%2Fapps.apple.com%2Fbr%2Fapp%2Fstarlight-mapa-do-c%25C3%25A9u%2Fid762002305&chld=L|0');return false;">C&oacute;digo QR</a></span></div>
                </div><p>Explore as estrelas.</p><hr /><div class="appbox"><div class="appbox-icon"><a href="https://apps.apple.com/br/app/eta-arrive-on-time/id803736422" target="_blank"><img class="appbox-iconiOS" alt="&Iacute;cone do app ETA - Arrive on time" src="https://is1-ssl.mzstatic.com/image/thumb/Purple116/v4/25/73/8e/25738efd-1604-eb79-3483-02f21296cea6/AppIcon-1x_U007emarketing-0-4-0-85-220.png/256x256bb.png" /></a></div><div class="appbox-details"><span class="appbox-name"><a href="https://apps.apple.com/br/app/eta-arrive-on-time/id803736422" target="_blank">ETA - Arrive on time</a></span><span class="appbox-de">de <strong><a href="http://whatsmyeta.co" target="_blank" class="no_icon" rel="nofollow">Eastwood</a></strong></span><div class="appbox-devices"><img src="https://macmagazine.com.br/wp-content/uploads/2015/11/devices_iphone.png" alt="Compat&iacute;vel com iPhones" title="Compat&iacute;vel com iPhones" class="appbox-devicesiPhone" /><img src="https://macmagazine.com.br/wp-content/uploads/2015/11/devices_watch.png" alt="Compat&iacute;vel com Apple Watches" title="Compat&iacute;vel com Apple Watches" class="appbox-devicesWatch" /><img src="https://macmagazine.com.br/wp-content/uploads/2017/09/16-imessage_icon.png" alt="Compat&iacute;vel com o iMessage" title="Compat&iacute;vel com o iMessage" class="appbox-iMessage" /></div><div class="appbox-info">Vers&atilde;o <strong>2.5.1</strong> (16.9 MB)<br />
                    Requer o <strong>iOS 13.0</strong> ou superior</div></div><div class="appbox-badge"><span class="appbox-price">R$ 44,90 <b class="appbox-oldprice">R$ 54.90</b></span><span><a href="https://apps.apple.com/br/app/eta-arrive-on-time/id803736422" target="_blank"><img alt="Badge - Baixar na App Store" src="https://macmagazine.com.br/wp-content/uploads/2017/11/22-badge_appstore.png" class="badgeInvert" /></a></span><span class="appbox-QRcode"><a href="javascript:void(0);" title="C&oacute;digo QR - ETA - Arrive on time" onclick="javascript:abrirQR('https://chart.googleapis.com/chart?chs=400x400&cht=qr&chl=https%3A%2F%2Fapps.apple.com%2Fbr%2Fapp%2Feta-arrive-on-time%2Fid803736422&chld=L|0');return false;"><img alt="C&oacute;digo QR" src="https://macmagazine.com.br/wp-content/themes/newsblock-child/images/qr.png" /></a><a href="javascript:void(0);" title="C&oacute;digo QR - ETA - Arrive on time" onclick="javascript:abrirQR('https://chart.googleapis.com/chart?chs=400x400&cht=qr&chl=https%3A%2F%2Fapps.apple.com%2Fbr%2Fapp%2Feta-arrive-on-time%2Fid803736422&chld=L|0');return false;">C&oacute;digo QR</a></span></div>
                </div><p>Utilitário para trânsito e direção.</p><hr /><div class="appbox"><div class="appbox-icon"><a href="https://apps.apple.com/br/app/the-christmas-list/id340779800" target="_blank"><img class="appbox-iconiOS" alt="&Iacute;cone do app The Christmas List" src="https://is1-ssl.mzstatic.com/image/thumb/Purple125/v4/67/ba/5c/67ba5caf-ca04-7e48-b9ac-a4080ab96058/AppIcon-1x_U007emarketing-0-6-0-85-220.jpeg/256x256bb.png" /></a></div><div class="appbox-details"><span class="appbox-name"><a href="https://apps.apple.com/br/app/the-christmas-list/id340779800" target="_blank">The Christmas List</a></span><span class="appbox-de">de <strong><a href="http://www.Limbua.com/" target="_blank" class="no_icon" rel="nofollow">Erik Eggleston</a></strong></span><div class="appbox-devices"><img src="https://macmagazine.com.br/wp-content/uploads/2015/11/devices_iphone.png" alt="Compat&iacute;vel com iPhones" title="Compat&iacute;vel com iPhones" class="appbox-devicesiPhone" /><img src="https://macmagazine.com.br/wp-content/uploads/2017/09/16-imessage_icon.png" alt="Compat&iacute;vel com o iMessage" title="Compat&iacute;vel com o iMessage" class="appbox-iMessage" /></div><div class="appbox-info">Vers&atilde;o <strong>4.0</strong> (14.3 MB)<br />
                    Requer o <strong>iOS 13.6</strong> ou superior</div></div><div class="appbox-badge"><span class="appbox-price">R$ 4,90 <b class="appbox-oldprice">R$ 16.90</b></span><span><a href="https://apps.apple.com/br/app/the-christmas-list/id340779800" target="_blank"><img alt="Badge - Baixar na App Store" src="https://macmagazine.com.br/wp-content/uploads/2017/11/22-badge_appstore.png" class="badgeInvert" /></a></span><span class="appbox-QRcode"><a href="javascript:void(0);" title="C&oacute;digo QR - The Christmas List" onclick="javascript:abrirQR('https://chart.googleapis.com/chart?chs=400x400&cht=qr&chl=https%3A%2F%2Fapps.apple.com%2Fbr%2Fapp%2Fthe-christmas-list%2Fid340779800&chld=L|0');return false;"><img alt="C&oacute;digo QR" src="https://macmagazine.com.br/wp-content/themes/newsblock-child/images/qr.png" /></a><a href="javascript:void(0);" title="C&oacute;digo QR - The Christmas List" onclick="javascript:abrirQR('https://chart.googleapis.com/chart?chs=400x400&cht=qr&chl=https%3A%2F%2Fapps.apple.com%2Fbr%2Fapp%2Fthe-christmas-list%2Fid340779800&chld=L|0');return false;">C&oacute;digo QR</a></span></div>
                </div><p>Utilitário para presentes de Natal.</p><h2>App para macOS</h2><hr /><div class="appbox"><div class="appbox-icon"><a href="https://apps.apple.com/br/app/total-video-player/id919402022?mt=12" target="_blank"><img alt="&Iacute;cone do app Total Video Player" src="https://is5-ssl.mzstatic.com/image/thumb/Purple125/v4/b1/5a/b6/b15ab6f3-87bb-437b-d7c8-231ed1d6d311/AppIcon-85-220-4-2x.png/256x256bb.png" /></a></div><div class="appbox-details"><span class="appbox-name"><a href="https://apps.apple.com/br/app/total-video-player/id919402022?mt=12" target="_blank">Total Video Player</a></span><span class="appbox-de">de <strong><a href="http://www.macvideostudio.com/total-video-player-mac.html" target="_blank" class="no_icon" rel="nofollow">effectmatrix</a></strong></span><div class="appbox-devices"><img src="https://macmagazine.com.br/wp-content/uploads/2015/11/devices_mac.png" alt="Compat&iacute;vel com Macs" title="Compat&iacute;vel com Macs" class="appbox-devicesMac" /></div><div class="appbox-info">Vers&atilde;o <strong>3.1.0</strong> (24.9 MB)<br />
                    Requer o <strong>macOS 10.9</strong> ou superior</div></div><div class="appbox-badge"><span class="appbox-price">R$ 54,90</span><span><a href="https://apps.apple.com/br/app/total-video-player/id919402022?mt=12" target="_blank"><img alt="Badge - Baixar na Mac App Store" src="https://macmagazine.com.br/wp-content/uploads/2017/11/22-badge_macappstore.png" class="badgeInvert" /></a></span><span class="appbox-QRcode"><a href="javascript:void(0);" title="C&oacute;digo QR - Total Video Player" onclick="javascript:abrirQR('https://chart.googleapis.com/chart?chs=400x400&cht=qr&chl=https%3A%2F%2Fapps.apple.com%2Fbr%2Fapp%2Ftotal-video-player%2Fid919402022%3Fmt%3D12&chld=L|0');return false;"><img alt="C&oacute;digo QR" src="https://macmagazine.com.br/wp-content/themes/newsblock-child/images/qr.png" /></a><a href="javascript:void(0);" title="C&oacute;digo QR - Total Video Player" onclick="javascript:abrirQR('https://chart.googleapis.com/chart?chs=400x400&cht=qr&chl=https%3A%2F%2Fapps.apple.com%2Fbr%2Fapp%2Ftotal-video-player%2Fid919402022%3Fmt%3D12&chld=L|0');return false;">C&oacute;digo QR</a></span></div>
                </div><p>Reprodutor de vídeos multiformatos.</p><hr class="wp-block-separator is-style-dots is-cnvs-separator-id-1618912657803"/><p>Aproveitem as ofertas e até amanhã. Ah, lembrando que elas são sempre por tempo limitado, então é bom correr!</p><p>Respeite o distanciamento social, use máscara (de preferência PFF2 ou N95) em ambientes fechados e vacine-se (se já chegou a sua hora de vacinar ou se chegou o momento da segunda dose ou da dose de reforço). <img src="https://s.w.org/images/core/emoji/13.1.0/72x72/1f3e0.png" alt="🏠" class="wp-smiley" style="height: 1em; max-height: 1em;" /><img src="https://s.w.org/images/core/emoji/13.1.0/72x72/1f637.png" alt="😷" class="wp-smiley" style="height: 1em; max-height: 1em;" /><img src="https://s.w.org/images/core/emoji/13.1.0/72x72/1f489.png" alt="💉" class="wp-smiley" style="height: 1em; max-height: 1em;" /></p>
]]>
</content:encoded>
<wfw:commentRss>https://macmagazine.com.br/post/2021/12/15/promocoes-na-app-store-rikudo-puzzles-starlight-total-video-player-e-mais/feed/</wfw:commentRss>
<slash:comments>0</slash:comments>
<post-id xmlns="com-wordpress:feed-additions:1">841579</post-id>
<media:content xmlns:media="http://search.yahoo.com/mrss/" medium="image" type="image/jpeg" url="https://macmagazine.com.br/wp-content/uploads/2021/12/15-Rikudo.png" width="984" height="502" />
</item>
<item>
    <title>Apple TV+ terá documentário sobre a música dos filmes de 007</title>
    <link>https://macmagazine.com.br/post/2021/12/15/apple-tv-tera-documentario-sobre-a-musica-dos-filmes-de-007/</link>
    <comments>https://macmagazine.com.br/post/2021/12/15/apple-tv-tera-documentario-sobre-a-musica-dos-filmes-de-007/#respond</comments>
    <dc:creator>
        <![CDATA[Bruno Santana]]>
    </dc:creator>
    <pubDate>Wed, 15 Dec 2021 22:35:24 +0000</pubDate>
    <category>
        <![CDATA[Apple]]>
    </category>
    <category>
        <![CDATA[Música]]>
    </category>
    <category>
        <![CDATA[Projetos]]>
    </category>
    <category>
        <![CDATA[007]]>
    </category>
    <category>
        <![CDATA[60 anos]]>
    </category>
    <category>
        <![CDATA[Apple Music]]>
    </category>
    <category>
        <![CDATA[Apple TV]]>
    </category>
    <category>
        <![CDATA[Apple TV+]]>
    </category>
    <category>
        <![CDATA[Canção]]>
    </category>
    <category>
        <![CDATA[documentário]]>
    </category>
    <category>
        <![CDATA[eon productions]]>
    </category>
    <category>
        <![CDATA[James Bond]]>
    </category>
    <category>
        <![CDATA[MGM]]>
    </category>
    <category>
        <![CDATA[the sound of 007]]>
    </category>
    <guid isPermaLink="false">https://macmagazine.com.br/?p=841559</guid>
    <description>
        <![CDATA[Depois de perder a batalha pelos direitos da franquia 007, a Apple parece ter desenvolvido uma afeição especial&#8230;]]>
    </description>
    <content:encoded>
        <![CDATA[<img width="1080" height="1080" src="https://macmagazine.com.br/wp-content/uploads/2021/12/15-apple-tv-the-sound-of-007.jpeg" class="webfeedsFeaturedVisual wp-post-image" alt="&quot;The Sound of 007&quot;" style="display: block; margin: auto; margin-bottom: 5px;max-width: 100%;" link_thumbnail="" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/15-apple-tv-the-sound-of-007.jpeg 1080w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-apple-tv-the-sound-of-007-600x600.jpeg 600w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-apple-tv-the-sound-of-007-300x300.jpeg 300w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-apple-tv-the-sound-of-007-80x80.jpeg 80w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-apple-tv-the-sound-of-007-110x110.jpeg 110w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-apple-tv-the-sound-of-007-380x380.jpeg 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-apple-tv-the-sound-of-007-800x800.jpeg 800w" sizes="(max-width: 1080px) 100vw, 1080px" /><p>Depois de <a href="https://macmagazine.com.br/post/2021/05/26/amazon-paga-mais-de-us8-bilhoes-pela-mgm-studios/">perder a batalha pelos direitos da franquia 007</a>, a Apple parece ter desenvolvido uma afeição especial por Bond,<strong>James Bond</strong>. Há alguns meses, a plataforma<a href="https://macmagazine.com.br/post/2021/09/07/documentario-ser-james-bond-ja-esta-disponivel-gratuitamente/">lançou, gratuita e exclusivamente, o documentário &#8220;Ser James Bond&#8221;</a>; agora, já temos notícias de mais um conteúdo relacionado ao icônico agente secreto britânico.</p><p><a href="https://deadline.com/2021/12/apple-documentary-music-of-james-bond-1234891760/">De acordo com o <em>Deadline</em></a>, a Maçã está planejando um documentário, atualmente intitulado <strong><em>&#8220;The Sound of 007&#8221;</em></strong>, que mergulhará em um dos aspectos mais memoráveis da franquia: a música, é claro.</p><figure class="wp-block-embed aligncenter is-type-rich is-provider-twitter wp-block-embed-twitter"><div class="wp-block-embed__wrapper"><blockquote class="twitter-tweet" data-width="550" data-dnt="true"><p lang="en" dir="ltr">To mark the 60th anniversary of the James Bond series, Apple are releasing a new documentary “The Sound of 007” in October 2022 on <a href="https://twitter.com/AppleTV?ref_src=twsrc%5Etfw">@AppleTV</a>.<a href="https://t.co/bZw2aZEWUm">pic.twitter.com/bZw2aZEWUm</a></p>&mdash; James Bond (@007) <a href="https://twitter.com/007/status/1471228227960123393?ref_src=twsrc%5Etfw">December 15, 2021</a></blockquote><script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script></div></figure><p>Uma produção conjunta da <strong>MGM</strong> (<a href="https://macmagazine.com.br/post/2021/05/26/amazon-paga-mais-de-us8-bilhoes-pela-mgm-studios/">adquirida pela Amazon</a>), da<strong>EON Productions</strong> e da<strong>Ventureland</strong>, o documentário fará uma viagem de décadas entre as origens de<em><a href="https://tv.apple.com/br/movie/007---contra-o-satanico-dr-no/umc.cmc.6m8uvpjzh34smgcyycsj35jux?at=10lt3B">&#8220;Dr. No&#8221;</a></em>, lá em 1962, até a produção de <em><a href="https://music.apple.com/br/album/no-time-to-die-single/1498647640?at=10lt3B">&#8220;No Time To Die&#8221;</a></em>, canção-tema de &#8220;007 &#8211; Sem Tempo Para Morrer&#8221; executada por <strong>Billie Eilish</strong>.</p><p>Nesse processo, pode ter certeza de que teremos a aparição de pessoas e composições eternizadas pelo tempo, como os temas compostos por <strong>John Barry</strong> e<strong>David Arnold</strong>, e clássicos como<em><a href="https://music.apple.com/br/album/live-and-let-die/1443000559?i=1443000563&amp;at=10lt3B">&#8220;Live and Let Die&#8221;</a></em>, de <strong>Paul McCartney</strong> com os Wings,<em><a href="https://music.apple.com/br/album/nobody-does-it-better/715595015?i=715595121&amp;at=10lt3B">&#8220;Nobody Does It Better&#8221;</a></em>, de <strong>Carly Simon</strong>, ou<em><a href="https://music.apple.com/br/album/skyfall-single/566322358?at=10lt3B">&#8220;Skyfall&#8221;</a></em>, de <strong>Adele</strong>. A direção será de<strong>Mat Whitecross</strong>, que comandou o documentário<em>&#8220;Coldplay: A Head Full of Dreams&#8221;</em>.</p><p><em>&#8220;The Sound of 007&#8221;</em> estreará em<strong>outubro de 2022</strong>, mês em que a saga de James Bond nos cinemas completará 60 anos. Certamente, dado o tema da produção, veremos uma combinação interessante do Apple TV+ com o Apple Music para o documentário.</p><p>Quem vai assistir? Eu, enquanto <em>bondfã</em> de carteirinha, já estou grudado na frente da TV.<img src="https://s.w.org/images/core/emoji/13.1.0/72x72/1f61c.png" alt="😜" class="wp-smiley" style="height: 1em; max-height: 1em;" /></p><p>O Apple TV+ está disponível no app Apple TV em mais de 100 países e regiões, seja em iPhones, iPads, Apple TVs, Macs, smart TVs ou online — além também estar em aparelhos como Roku, Amazon Fire TV, Chromecast com Google TV, consoles PlayStation e Xbox. O serviço <a href="https://apple.co/2Z6v2i4">custa <strong>R$9,90 por mês</strong></a>, com um período de teste gratuito de sete dias. Por tempo limitado, quem comprar e ativar um novo iPhone, iPad, Apple TV, Mac ou iPod touch ganha três meses de Apple TV+. Ele também faz parte do pacote de assinaturas da empresa, o <a href="https://macmagazine.com.br/post/2020/10/30/apple-one-esta-agora-disponivel-veja-como-assinar/">Apple One</a>.</p><hr /><div class="appbox"><div class="appbox-icon"><a href="https://apps.apple.com/br/app/apple-tv/id1174078549" target="_blank"><img class="appbox-iconiOS" alt="&Iacute;cone do app Apple TV" src="https://is5-ssl.mzstatic.com/image/thumb/Purple116/v4/42/6e/37/426e37bf-dcbd-79a1-2927-cd7889239dad/AppIcon-0-0-1x_U007emarketing-0-0-0-7-0-0-sRGB-0-0-0-GLES2_U002c0-512MB-85-220-0-0.png/256x256bb.png" /></a></div><div class="appbox-details"><span class="appbox-name"><a href="https://apps.apple.com/br/app/apple-tv/id1174078549" target="_blank">Apple TV</a></span><span class="appbox-de">de <strong><a href="https://www.apple.com/br/apple-tv-app/" target="_blank" class="no_icon" rel="nofollow">Apple</a></strong></span><div class="appbox-devices"><img src="https://macmagazine.com.br/wp-content/uploads/2015/11/devices_ipad.png" alt="Compat&iacute;vel com iPads" title="Compat&iacute;vel com iPads" class="appbox-devicesiPad" /><img src="https://macmagazine.com.br/wp-content/uploads/2015/11/devices_iphone.png" alt="Compat&iacute;vel com iPhones" title="Compat&iacute;vel com iPhones" class="appbox-devicesiPhone" /></div><div class="appbox-info">Vers&atilde;o <strong>1.7</strong> (888.8 KB)<br />
                    Requer o <strong>iOS 10.2</strong> ou superior</div></div><div class="appbox-badge"><span class="appbox-price">Gr&aacute;tis</span><span><a href="https://apps.apple.com/br/app/apple-tv/id1174078549" target="_blank"><img alt="Badge - Baixar na App Store" src="https://macmagazine.com.br/wp-content/uploads/2017/11/22-badge_appstore.png" class="badgeInvert" /></a></span><span class="appbox-QRcode"><a href="javascript:void(0);" title="C&oacute;digo QR - Apple TV" onclick="javascript:abrirQR('https://chart.googleapis.com/chart?chs=400x400&cht=qr&chl=https%3A%2F%2Fapps.apple.com%2Fbr%2Fapp%2Fapple-tv%2Fid1174078549&chld=L|0');return false;"><img alt="C&oacute;digo QR" src="https://macmagazine.com.br/wp-content/themes/newsblock-child/images/qr.png" /></a><a href="javascript:void(0);" title="C&oacute;digo QR - Apple TV" onclick="javascript:abrirQR('https://chart.googleapis.com/chart?chs=400x400&cht=qr&chl=https%3A%2F%2Fapps.apple.com%2Fbr%2Fapp%2Fapple-tv%2Fid1174078549&chld=L|0');return false;">C&oacute;digo QR</a></span></div>
                </div>
]]>
</content:encoded>
<wfw:commentRss>https://macmagazine.com.br/post/2021/12/15/apple-tv-tera-documentario-sobre-a-musica-dos-filmes-de-007/feed/</wfw:commentRss>
<slash:comments>0</slash:comments>
<post-id xmlns="com-wordpress:feed-additions:1">841559</post-id>
<media:content xmlns:media="http://search.yahoo.com/mrss/" medium="image" type="image/jpeg" url="https://macmagazine.com.br/wp-content/uploads/2021/12/15-apple-tv-the-sound-of-007.jpeg" width="1080" height="1080" />
</item>
<item>
    <title>Apple fecha 3 lojas de uma vez após novos surtos de COVID-19</title>
    <link>https://macmagazine.com.br/post/2021/12/15/apple-fecha-3-lojas-de-uma-vez-apos-novos-surtos-de-covid-19/</link>
    <comments>https://macmagazine.com.br/post/2021/12/15/apple-fecha-3-lojas-de-uma-vez-apos-novos-surtos-de-covid-19/#respond</comments>
    <dc:creator>
        <![CDATA[Douglas Nascimento]]>
    </dc:creator>
    <pubDate>Wed, 15 Dec 2021 22:06:00 +0000</pubDate>
    <category>
        <![CDATA[Apple]]>
    </category>
    <category>
        <![CDATA[Off-Topic]]>
    </category>
    <category>
        <![CDATA[Annapolis]]>
    </category>
    <category>
        <![CDATA[Apple Store]]>
    </category>
    <category>
        <![CDATA[Apple Stores]]>
    </category>
    <category>
        <![CDATA[Brickell City Center]]>
    </category>
    <category>
        <![CDATA[Canadá]]>
    </category>
    <category>
        <![CDATA[COVID]]>
    </category>
    <category>
        <![CDATA[COVID-19]]>
    </category>
    <category>
        <![CDATA[Estados Unidos]]>
    </category>
    <category>
        <![CDATA[EUA]]>
    </category>
    <category>
        <![CDATA[Fechada]]>
    </category>
    <category>
        <![CDATA[Flórida]]>
    </category>
    <category>
        <![CDATA[lojas]]>
    </category>
    <category>
        <![CDATA[Maryland]]>
    </category>
    <category>
        <![CDATA[miami]]>
    </category>
    <category>
        <![CDATA[Ômicron]]>
    </category>
    <category>
        <![CDATA[Ottawa]]>
    </category>
    <category>
        <![CDATA[pandemia]]>
    </category>
    <guid isPermaLink="false">https://macmagazine.com.br/?p=841509</guid>
    <description>
        <![CDATA[Quando a gente achava que a situação envolvendo a pandemia da COVID-19 estaria majoritariamente controlada neste fim de&#8230;]]>
    </description>
    <content:encoded>
        <![CDATA[<img width="1200" height="800" src="https://macmagazine.com.br/wp-content/uploads/2021/12/15-loja-apple-covid-19-1260x840.jpg" class="webfeedsFeaturedVisual wp-post-image" alt="Loja da Apple fechada por conta da pandemia da COVID-19" style="display: block; margin: auto; margin-bottom: 5px;max-width: 100%;" link_thumbnail="" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/15-loja-apple-covid-19-1260x840.jpg 1260w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-loja-apple-covid-19-600x400.jpg 600w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-loja-apple-covid-19-300x200.jpg 300w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-loja-apple-covid-19-1536x1024.jpg 1536w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-loja-apple-covid-19-2048x1365.jpg 2048w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-loja-apple-covid-19-380x253.jpg 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-loja-apple-covid-19-800x533.jpg 800w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-loja-apple-covid-19-1160x773.jpg 1160w" sizes="(max-width: 1200px) 100vw, 1200px" /><p>Quando a gente achava que a situação envolvendo a pandemia da <strong>COVID-19</strong> estaria majoritariamente controlada neste fim de ano, não é bem isso que vem acontecendo. Nos Estados Unidos, por exemplo, a não vacinação por parte de parcela da população, bem como a disseminação da variante<strong>Ômicron</strong>, vêm promovendo novos surtos do vírus pelo país.</p><p>A <strong>Apple</strong>, inclusive, teve de fechar agora três lojas de varejo nos EUA e no Canadá após novos surtos da doença<strong> </strong>em<strong>Miami</strong> (Flórida),<strong>Annapolis</strong> (Maryland) e<strong>Ottawa</strong> (Canadá).</p><p>O fechamento das lojas se deu devido ao aumento dos casos internos e deverá durar alguns dias, tempo necessário para que todos os funcionários façam testes de COVID-19 e para que tudo seja restabelecido com segurança.</p><p>Em comunicado, a Apple afirmou que monitora regularmente as condições de trabalho e que ajustará suas &#8220;medidas de saúde para apoiar o bem-estar dos clientes e funcionários&#8221;, deixando claro que tomará todos os cuidados necessários para manter tudo seguro:</p><blockquote class="wp-block-quote"><p>Continuamos comprometidos com uma abordagem abrangente para nossas equipes que combina testes regulares com verificações diárias de saúde, mascaramento de funcionários e clientes, limpeza profunda e licença médica remunerada.</p></blockquote><p><a href="https://www.bloomberg.com/news/articles/2021-12-15/apple-temporarily-shuts-three-retail-stores-after-covid-19-surge">De acordo com a <em>Bloomberg</em></a>, a Apple só havia precisado fechar uma loja de cada vez desde a reabertura total, no início deste ano, nunca mais que isso. Na semana passada, por exemplo, <a href="https://macmagazine.com.br/post/2021/12/09/loja-da-apple-no-texas-fecha-apos-casos-de-covid-19-na-equipe/">a empresa fechou uma loja no Texas</a> pelo mesmo motivo.</p><p>A empresa, vale recordar, vem fazendo de tudo para impedir esse tipo de problema. Recentemente, por exemplo, ela passou a <a href="https://macmagazine.com.br/post/2021/10/20/apple-exigira-testes-mais-frequentes-de-funcionarios-nao-vacinados/">exigir testes rápidos dos funcionários periodicamente</a> e orienta aos que tenham sintomas que permaneçam em casa.</p>
]]>
</content:encoded>
<wfw:commentRss>https://macmagazine.com.br/post/2021/12/15/apple-fecha-3-lojas-de-uma-vez-apos-novos-surtos-de-covid-19/feed/</wfw:commentRss>
<slash:comments>0</slash:comments>
<post-id xmlns="com-wordpress:feed-additions:1">841509</post-id>
<media:content xmlns:media="http://search.yahoo.com/mrss/" medium="image" type="image/jpeg" url="https://macmagazine.com.br/wp-content/uploads/2021/12/15-loja-apple-covid-19-1260x840.jpg" width="1200" height="800" />
</item>
<item>
    <title>Apple e LG estariam trabalhando em sucessor do Pro Display XDR</title>
    <link>https://macmagazine.com.br/post/2021/12/15/apple-e-lg-estariam-trabalhando-em-sucessor-do-pro-display-xdr/</link>
    <comments>https://macmagazine.com.br/post/2021/12/15/apple-e-lg-estariam-trabalhando-em-sucessor-do-pro-display-xdr/#respond</comments>
    <dc:creator>
        <![CDATA[Bruno Cardoso]]>
    </dc:creator>
    <pubDate>Wed, 15 Dec 2021 21:52:11 +0000</pubDate>
    <category>
        <![CDATA[Apple]]>
    </category>
    <category>
        <![CDATA[Hardware]]>
    </category>
    <category>
        <![CDATA[Rumores]]>
    </category>
    <category>
        <![CDATA[120Hz]]>
    </category>
    <category>
        <![CDATA[dylandkt]]>
    </category>
    <category>
        <![CDATA[leaker]]>
    </category>
    <category>
        <![CDATA[LG]]>
    </category>
    <category>
        <![CDATA[Mac]]>
    </category>
    <category>
        <![CDATA[Mini-LED]]>
    </category>
    <category>
        <![CDATA[Monitor]]>
    </category>
    <category>
        <![CDATA[Monitor profissional]]>
    </category>
    <category>
        <![CDATA[Pro Display XDR]]>
    </category>
    <category>
        <![CDATA[ProMotion]]>
    </category>
    <category>
        <![CDATA[Thunderbolt Display]]>
    </category>
    <category>
        <![CDATA[vazamentos]]>
    </category>
    <guid isPermaLink="false">https://macmagazine.com.br/?p=841507</guid>
    <description>
        <![CDATA[Novos rumores apontam que a LG pode estar desenvolvendo um sucessor do Pro Display XDR, da Apple, além&#8230;]]>
    </description>
    <content:encoded>
        <![CDATA[<img width="1038" height="1260" src="https://macmagazine.com.br/wp-content/uploads/2021/12/15-pro-display-xdr-1038x1260.jpg" class="webfeedsFeaturedVisual wp-post-image" alt="Pro Display XDR" style="display: block; margin: auto; margin-bottom: 5px;max-width: 100%;" link_thumbnail="" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/15-pro-display-xdr-1038x1260.jpg 1038w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-pro-display-xdr-494x600.jpg 494w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-pro-display-xdr-247x300.jpg 247w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-pro-display-xdr-1265x1536.jpg 1265w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-pro-display-xdr-1687x2048.jpg 1687w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-pro-display-xdr-380x461.jpg 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-pro-display-xdr-800x971.jpg 800w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-pro-display-xdr-1160x1408.jpg 1160w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-pro-display-xdr-scaled.jpg 3374w" sizes="(max-width: 1038px) 100vw, 1038px" /><p>Novos rumores apontam que a <strong>LG </strong>pode estar desenvolvendo um sucessor do<strong>Pro Display XDR</strong>, da<strong>Apple</strong>, além de dois novos monitores de entrada para a companhia — aos moldes do antigo Thunderbolt Display,<a href="https://macmagazine.com.br/post/2016/06/23/apos-cinco-anos-sem-atualizacao-apple-oficializa-a-morte-do-thunderbolt-display/">descontinuado em 2016</a>.</p><p>Segundo o <em>leaker</em><a href="https://twitter.com/dylandkt">@dylandkt</a>, a empresa sul-coreana estaria desenvolvendo dois monitores (um de 24 e outro de 27 polegadas) baseados no novo iMac de 24&#8243;, apresentado pela Apple em abril. Além disso, um outro display de 32&#8243;, similar ao atual Pro Display XDR, também teria sido &#8220;flagrado&#8221; pelo<em>leaker</em>.</p><figure class="wp-block-embed aligncenter is-type-rich is-provider-twitter wp-block-embed-twitter"><div class="wp-block-embed__wrapper"><blockquote class="twitter-tweet" data-width="550" data-dnt="true"><p lang="en" dir="ltr"><img src="https://s.w.org/images/core/emoji/13.1.0/72x72/1f9f5.png" alt="🧵" class="wp-smiley" style="height: 1em; max-height: 1em;" />Thread 1/4: There are three LG made Displays encased in unbranded enclosures for usage as external monitors that are in early development. Two of which have the same specifications as the upcoming 27 inch and current 24 inch iMac displays.</p>&mdash; Dylan (@dylandkt) <a href="https://twitter.com/dylandkt/status/1471186599547490312?ref_src=twsrc%5Etfw">December 15, 2021</a></blockquote><script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script></div></figure><p>Em tweets, Dylan afirma que os três monitores estão, atualmente, montados em carcaças sem nenhuma identificação ou logo, mas que considera seguro acreditar que pelo menos um deles se trate de um produto destinado à Maçã, uma vez que a versão de 32&#8243; parece contar um chip da Apple não especificado.</p><figure class="wp-block-embed aligncenter is-type-rich is-provider-twitter wp-block-embed-twitter"><div class="wp-block-embed__wrapper"><blockquote class="twitter-tweet" data-width="550" data-dnt="true"><p lang="en" dir="ltr">Thread 2/4: The other display seems to be an improved 32 inch Pro Display XDR. Despite the lack of branding, It can be assumed at the very least that this display will be Apple branded.</p>&mdash; Dylan (@dylandkt)<a href="https://twitter.com/dylandkt/status/1471186760965238792?ref_src=twsrc%5Etfw">December 15, 2021</a></blockquote><script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script></div></figure><p>Vale lembrar que, <a href="https://macmagazine.com.br/post/2021/07/23/apple-estaria-trabalhando-em-novo-monitor-com-chip-a13-e-neural-engine/">em julho</a>, surgiram rumores de que a Apple estaria trabalhando em um novo monitor profissional que contaria com o chip<strong>A13 Bionic</strong> e<strong>Neural Engine</strong>. Tal característica seria capaz de tornar o monitor ainda mais rápido ou, até mesmo, melhorar a performance gráfica de Macs. Dylan, contudo, não confirmou se esse modelo se trata do mesmo desenvolvido pela LG.</p><p>Além disso, tanto o monitor de 32&#8243; quanto o de 27&#8243; parecem contar com telas <strong>Mini-LED</strong> compatíveis com a tecnologia<strong>ProMotion</strong>, que permite taxas de atualização variáveis de até 120Hz.</p><p>Embora o <em>leaker</em> tenha um histórico relativamente curto de previsões relacionadas aos produtos Apple, seus vazamentos costumam ter um alto grau de precisão. Dylan é conhecido, por exemplo, por ter previsto a chegada do chip M1 ao iPads Pro e as webcams Full HD (1080p) nos novos MacBooks Pro.</p><p>Veremos…</p><hr><div class="appbox"><div class="appbox-icon"><a href="https://apple.sjv.io/eM6dj"><img width="600" height="495" src="https://macmagazine.com.br/wp-content/uploads/2021/04/12-pro-display-xdr-600x495.jpeg" alt="Pro Display XDR" class="wp-image-776146" srcset="https://macmagazine.com.br/wp-content/uploads/2021/04/12-pro-display-xdr-600x495.jpeg 600w, https://macmagazine.com.br/wp-content/uploads/2021/04/12-pro-display-xdr-1260x1039.jpeg 1260w, https://macmagazine.com.br/wp-content/uploads/2021/04/12-pro-display-xdr-300x247.jpeg 300w, https://macmagazine.com.br/wp-content/uploads/2021/04/12-pro-display-xdr-1536x1267.jpeg 1536w, https://macmagazine.com.br/wp-content/uploads/2021/04/12-pro-display-xdr-2048x1689.jpeg 2048w, https://macmagazine.com.br/wp-content/uploads/2021/04/12-pro-display-xdr-380x313.jpeg 380w, https://macmagazine.com.br/wp-content/uploads/2021/04/12-pro-display-xdr-800x660.jpeg 800w, https://macmagazine.com.br/wp-content/uploads/2021/04/12-pro-display-xdr-1160x957.jpeg 1160w, https://macmagazine.com.br/wp-content/uploads/2021/04/12-pro-display-xdr.jpeg 2832w" sizes="(max-width: 600px) 100vw, 600px" /></a></div><div class="appbox-details"><span class="appbox-name"><a href="https://apple.sjv.io/eM6dj">Pro Display XDR</a></span><span class="appbox-de">de <strong>Apple</strong></span><span><small><strong>Preço à vista:</strong> a partir de R$40.499,10<br><strong>Preço parcelado:</strong> em até 12x de R$3.749,92<br><strong>Lançamento:</strong> 2019</small></span></div><div class="appbox-badge"><span style="float: right;"><a href="https://apple.sjv.io/eM6dj" class="botaoComprar">Comprar</a></span></div></div><p class="notaTransparencia">NOTA DE TRANSPARÊNCIA: O <strong><em>MacMagazine</em></strong> recebe uma pequena comissão de vendas concluídas por meio de links deste post, mas você, como consumidor, não paga nada mais pelos produtos comprando pelos nossos links de afiliado.</p>
]]>
</content:encoded>
<wfw:commentRss>https://macmagazine.com.br/post/2021/12/15/apple-e-lg-estariam-trabalhando-em-sucessor-do-pro-display-xdr/feed/</wfw:commentRss>
<slash:comments>0</slash:comments>
<post-id xmlns="com-wordpress:feed-additions:1">841507</post-id>
<media:content xmlns:media="http://search.yahoo.com/mrss/" medium="image" type="image/jpeg" url="https://macmagazine.com.br/wp-content/uploads/2021/12/15-pro-display-xdr-1038x1260.jpg" width="1038" height="1260" />
</item>
<item>
    <title>Brasil foi o 3º país que mais baixou apps em 2021</title>
    <link>https://macmagazine.com.br/post/2021/12/15/brasil-foi-o-3o-pais-que-mais-baixou-apps-em-2021/</link>
    <comments>https://macmagazine.com.br/post/2021/12/15/brasil-foi-o-3o-pais-que-mais-baixou-apps-em-2021/#respond</comments>
    <dc:creator>
        <![CDATA[Bruno Cardoso]]>
    </dc:creator>
    <pubDate>Wed, 15 Dec 2021 20:56:35 +0000</pubDate>
    <category>
        <![CDATA[Gadgets]]>
    </category>
    <category>
        <![CDATA[Jogos]]>
    </category>
    <category>
        <![CDATA[Pesquisa]]>
    </category>
    <category>
        <![CDATA[Software]]>
    </category>
    <category>
        <![CDATA[Android]]>
    </category>
    <category>
        <![CDATA[aplicativos]]>
    </category>
    <category>
        <![CDATA[app]]>
    </category>
    <category>
        <![CDATA[App Annie]]>
    </category>
    <category>
        <![CDATA[App Store]]>
    </category>
    <category>
        <![CDATA[apps]]>
    </category>
    <category>
        <![CDATA[Discord]]>
    </category>
    <category>
        <![CDATA[downloads]]>
    </category>
    <category>
        <![CDATA[Google Play]]>
    </category>
    <category>
        <![CDATA[iOS]]>
    </category>
    <category>
        <![CDATA[iPhone]]>
    </category>
    <category>
        <![CDATA[Pesquisa de Mercado]]>
    </category>
    <category>
        <![CDATA[ranking]]>
    </category>
    <category>
        <![CDATA[Telegram]]>
    </category>
    <category>
        <![CDATA[TikTok]]>
    </category>
    <guid isPermaLink="false">https://macmagazine.com.br/?p=841453</guid>
    <description>
        <![CDATA[A App Annie divulgou a nova versão do seu tradicional relatório sobre o mercado de apps. Dessa vez,&#8230;]]>
    </description>
    <content:encoded>
        <![CDATA[<img width="1200" height="800" src="https://macmagazine.com.br/wp-content/uploads/2021/07/23-apps-de-redes-sociais-1260x840.jpg" class="webfeedsFeaturedVisual wp-post-image" alt="Ícones de apps (Snapchat, Instagram, Facebook, YouTube, WhatsApp, Twitter, TikTok, Reddit, Telegram e Zoom)" style="display: block; margin: auto; margin-bottom: 5px;max-width: 100%;" link_thumbnail="" srcset="https://macmagazine.com.br/wp-content/uploads/2021/07/23-apps-de-redes-sociais-1260x840.jpg 1260w, https://macmagazine.com.br/wp-content/uploads/2021/07/23-apps-de-redes-sociais-600x400.jpg 600w, https://macmagazine.com.br/wp-content/uploads/2021/07/23-apps-de-redes-sociais-300x200.jpg 300w, https://macmagazine.com.br/wp-content/uploads/2021/07/23-apps-de-redes-sociais-1536x1024.jpg 1536w, https://macmagazine.com.br/wp-content/uploads/2021/07/23-apps-de-redes-sociais-2048x1365.jpg 2048w, https://macmagazine.com.br/wp-content/uploads/2021/07/23-apps-de-redes-sociais-380x253.jpg 380w, https://macmagazine.com.br/wp-content/uploads/2021/07/23-apps-de-redes-sociais-800x533.jpg 800w, https://macmagazine.com.br/wp-content/uploads/2021/07/23-apps-de-redes-sociais-1160x773.jpg 1160w" sizes="(max-width: 1200px) 100vw, 1200px" /><p>A <strong>App Annie</strong> divulgou a nova versão do seu tradicional<a href="https://www.appannie.com/en/insights/market-data/2021-end-year-mobile-apps-recap/">relatório sobre o mercado de apps</a>. Dessa vez, os dados referentes ao ano de 2021 chegam com métricas animadoras para o aplicativo de mensagens<strong>Telegram</strong>, que sofreu um grande aumento no número de usuários ativos mensalmente.</p><p>De acordo com a pesquisa, o Telegram foi o app que obteve o maior crescimento relativo em comparação ao ano passado, à frente de outros gigantes do mercado como o <strong>Instagram</strong> e o<strong>Zoom</strong> (que permanece forte desde seu sucesso inicial, em 2020).</p><div class="wp-block-image"><figure class="aligncenter size-large"><a href="https://macmagazine.com.br/wp-content/uploads/2021/12/15-TopApps-AppAnnie.png"><img width="1260" height="712" src="https://macmagazine.com.br/wp-content/uploads/2021/12/15-TopApps-AppAnnie-1260x712.png" alt="" class="wp-image-841488" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/15-TopApps-AppAnnie-1260x712.png 1260w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-TopApps-AppAnnie-600x339.png 600w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-TopApps-AppAnnie-300x170.png 300w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-TopApps-AppAnnie-1536x869.png 1536w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-TopApps-AppAnnie-2048x1158.png 2048w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-TopApps-AppAnnie-380x215.png 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-TopApps-AppAnnie-800x452.png 800w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-TopApps-AppAnnie-1160x656.png 1160w" sizes="(max-width: 1260px) 100vw, 1260px" /></a></figure></div><p>O CEO<span id='easy-footnote-1-841453' class='easy-footnote-margin-adjust'></span><span class='easy-footnote'><a href='https://macmagazine.com.br/post/2021/12/15/brasil-foi-o-3o-pais-que-mais-baixou-apps-em-2021/#easy-footnote-bottom-1-841453' title='&lt;em&gt;Chief executive officer&lt;/em&gt;, ou diretor executivo.'><sup>1</sup></a></span> do mensageiro, <strong>Pavel Durov</strong>, comemorou o marco em seu canal pessoal no Telegram, onde divulgou uma mensagem de agradecimento e aproveitou para alfinetar a concorrência:</p><blockquote class="wp-block-quote"><p>As pessoas não querem mais trocar sua privacidade por serviços gratuitos. Eles não querem mais ser reféns de monopólios de tecnologia que parecem pensar que podem se safar de qualquer coisa, desde que seus aplicativos tenham uma massa crítica de usuários. Com meio bilhão de usuários ativos e crescimento acelerado, o Telegram se tornou o maior refúgio para quem busca uma plataforma de comunicação comprometida com a privacidade e a segurança. Levamos essa responsabilidade muito a sério. Não vamos decepcionar vocês.</p></blockquote><h2>Apps de redes sociais</h2><p>Entre os aplicativos de redes sociais, o <strong>TikTok</strong> aparece soberano em todas as listas levantadas pela pesquisa, figurando como o app mais popular tanto globalmente, quanto em mercados populares como os Estados Unidos e o Reino Unido. Os apps de transmissões ao vivo<strong>BIGO LIVE</strong> e de chamadas online<strong>Discord</strong> vêm logo atrás.</p><div class="wp-block-image"><figure class="aligncenter size-large"><a href="https://macmagazine.com.br/wp-content/uploads/2021/12/15-SocialApps-AppAnnie.png"><img width="1260" height="712" src="https://macmagazine.com.br/wp-content/uploads/2021/12/15-SocialApps-AppAnnie-1260x712.png" alt="" class="wp-image-841489" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/15-SocialApps-AppAnnie-1260x712.png 1260w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-SocialApps-AppAnnie-600x339.png 600w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-SocialApps-AppAnnie-300x170.png 300w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-SocialApps-AppAnnie-1536x869.png 1536w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-SocialApps-AppAnnie-2048x1158.png 2048w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-SocialApps-AppAnnie-380x215.png 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-SocialApps-AppAnnie-800x452.png 800w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-SocialApps-AppAnnie-1160x656.png 1160w" sizes="(max-width: 1260px) 100vw, 1260px" /></a></figure></div><p>O único app da <strong>Meta </strong>a aparecer nos rankings foi o<strong>Facebook</strong>, que ficou na quarta colocação tanto globalmente quanto em solo britânico. Nos EUA, a rede de Mark Zuckerberg apareceu na oitava posição.</p><p>Ainda segundo a App Annie, é esperado que o setor de aplicativos sociais lucre cerca de US$9 bilhões em 2022 — um aumento de 82% em relação a 2021.</p><h2>Serviços de streaming</h2><p>O <strong>YouTube </strong>manteve sua liderança no ranking global de apps de streaming, aparecendo como o serviço mais popular entre os usuários de iOS e Android. Mesmo assim, o serviço de vídeos do Google não conseguiu estabelecer sua hegemonia em sua terra natal e nem no Reino Unido, onde sequer apareceu no<em>Top 10</em>.</p><div class="wp-block-image"><figure class="aligncenter size-large"><a href="https://macmagazine.com.br/wp-content/uploads/2021/12/15-StreamingApps-AppAnnie.png"><img width="1260" height="712" src="https://macmagazine.com.br/wp-content/uploads/2021/12/15-StreamingApps-AppAnnie-1260x712.png" alt="" class="wp-image-841490" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/15-StreamingApps-AppAnnie-1260x712.png 1260w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-StreamingApps-AppAnnie-600x339.png 600w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-StreamingApps-AppAnnie-300x170.png 300w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-StreamingApps-AppAnnie-1536x869.png 1536w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-StreamingApps-AppAnnie-2048x1158.png 2048w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-StreamingApps-AppAnnie-380x215.png 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-StreamingApps-AppAnnie-800x452.png 800w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-StreamingApps-AppAnnie-1160x656.png 1160w" sizes="(max-width: 1260px) 100vw, 1260px" /></a></figure></div><p>Além disso, a pesquisa ressaltou o bom desempenho do HBO Max e, especialmente, do Disney+. Segundo os dados, os assinantes do serviço da empresa do Mickey passaram cerca de 975 bilhões de horas acumuladas assistindo aos filmes e séries da empresa.</p><h2>Jogos mobile</h2><p>Entre os destaques dos jogos mais populares do último ano está <strong>Bridge Race</strong>, que se estabeleceu como o jogo mobile mais baixado mundialmente, seguido por<strong>Hair Challenge</strong> e<strong>Count Masters</strong>.</p><div class="wp-block-image"><figure class="aligncenter size-large"><a href="https://macmagazine.com.br/wp-content/uploads/2021/12/15-Games-AppAnnie.jpg"><img width="1260" height="713" src="https://macmagazine.com.br/wp-content/uploads/2021/12/15-Games-AppAnnie-1260x713.jpg" alt="" class="wp-image-841491" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/15-Games-AppAnnie-1260x713.jpg 1260w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-Games-AppAnnie-600x339.jpg 600w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-Games-AppAnnie-300x170.jpg 300w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-Games-AppAnnie-1536x869.jpg 1536w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-Games-AppAnnie-380x215.jpg 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-Games-AppAnnie-800x453.jpg 800w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-Games-AppAnnie-1160x656.jpg 1160w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-Games-AppAnnie.jpg 1600w" sizes="(max-width: 1260px) 100vw, 1260px" /></a></figure></div><p>Ademais, os gêneros de jogos mais populares entre os gamers mobile foram de estratégia, RPG e simulação, os quais obtiveram crescimentos de 32%, 21% e 57% em relação ao ano passado, respectivamente.</p><p>Por fim, usuários de iOS e Android baixaram, combinados, mais de 140 bilhões de apps no geral — a <strong>Índia</strong> lidera essa marca com 20% do total, seguida pelos<strong>EUA</strong> com 9% e pelo<strong>Brasil</strong> com 8%.</p><p><span class="credito">via <a href="https://www.uol.com.br/tilt/noticias/redacao/2021/12/15/bombou-telegram-foi-o-app-que-mais-cresceu-em-2021-diz-ibope-dos-apps.htm">UOL Tilt</a></span></p>
]]>
</content:encoded>
<wfw:commentRss>https://macmagazine.com.br/post/2021/12/15/brasil-foi-o-3o-pais-que-mais-baixou-apps-em-2021/feed/</wfw:commentRss>
<slash:comments>0</slash:comments>
<post-id xmlns="com-wordpress:feed-additions:1">841453</post-id>
<media:content xmlns:media="http://search.yahoo.com/mrss/" medium="image" type="image/jpeg" url="https://macmagazine.com.br/wp-content/uploads/2021/07/23-apps-de-redes-sociais-1260x840.jpg" width="1200" height="800" />
</item>
<item>
    <title>Google Drive alertará sobre arquivos marcados como spam</title>
    <link>https://macmagazine.com.br/post/2021/12/15/google-drive-alertara-sobre-arquivos-marcados-como-spam/</link>
    <comments>https://macmagazine.com.br/post/2021/12/15/google-drive-alertara-sobre-arquivos-marcados-como-spam/#respond</comments>
    <dc:creator>
        <![CDATA[Douglas Nascimento]]>
    </dc:creator>
    <pubDate>Wed, 15 Dec 2021 20:44:41 +0000</pubDate>
    <category>
        <![CDATA[Internet]]>
    </category>
    <category>
        <![CDATA[Segurança]]>
    </category>
    <category>
        <![CDATA[Software]]>
    </category>
    <category>
        <![CDATA[aplicativos]]>
    </category>
    <category>
        <![CDATA[app]]>
    </category>
    <category>
        <![CDATA[App Store]]>
    </category>
    <category>
        <![CDATA[apps]]>
    </category>
    <category>
        <![CDATA[atualização]]>
    </category>
    <category>
        <![CDATA[Google Drive]]>
    </category>
    <category>
        <![CDATA[Google workspace]]>
    </category>
    <category>
        <![CDATA[iOS]]>
    </category>
    <category>
        <![CDATA[política]]>
    </category>
    <category>
        <![CDATA[spam]]>
    </category>
    <guid isPermaLink="false">https://macmagazine.com.br/?p=841480</guid>
    <description>
        <![CDATA[O compartilhamento de spam no Google Drive se tornou uma das maiores preocupações para o Google nos últimos&#8230;]]>
    </description>
    <content:encoded>
        <![CDATA[<img width="1200" height="500" src="https://macmagazine.com.br/wp-content/uploads/2020/10/06-Google-Workspace-1260x525.png" class="webfeedsFeaturedVisual wp-post-image" alt="Google Workspace" style="display: block; margin: auto; margin-bottom: 5px;max-width: 100%;" link_thumbnail="" srcset="https://macmagazine.com.br/wp-content/uploads/2020/10/06-Google-Workspace-1260x525.png 1260w, https://macmagazine.com.br/wp-content/uploads/2020/10/06-Google-Workspace-600x250.png 600w, https://macmagazine.com.br/wp-content/uploads/2020/10/06-Google-Workspace-300x125.png 300w, https://macmagazine.com.br/wp-content/uploads/2020/10/06-Google-Workspace-1536x640.png 1536w, https://macmagazine.com.br/wp-content/uploads/2020/10/06-Google-Workspace-2048x854.png 2048w, https://macmagazine.com.br/wp-content/uploads/2020/10/06-Google-Workspace.png 2200w" sizes="(max-width: 1200px) 100vw, 1200px" /><p>O compartilhamento de spam<span id='easy-footnote-1-841480' class='easy-footnote-margin-adjust'></span><span class='easy-footnote'><a href='https://macmagazine.com.br/post/2021/12/15/google-drive-alertara-sobre-arquivos-marcados-como-spam/#easy-footnote-bottom-1-841480' title='&lt;em&gt;Sending and posting advertisement in mass&lt;/em&gt;, ou enviar e postar publicidade em massa.'><sup>1</sup></a></span> no <strong>Google Drive</strong> se tornou uma das maiores preocupações para o Google nos últimos anos, e é por isso que a empresa anunciou ontem uma<a href="https://workspaceupdates.googleblog.com/2021/12/abuse-notification-emails-google-drive.html">nova atualização do <strong>Workspace</strong></a> para tentar amenizar esse problema.</p><p>Embora o Google tenha passado a permitir denunciar arquivos que ferem sua política contra spam, isso de pouco adiantou. Além de a medida não ser tão efetiva, ela ainda possibilitou que o compartilhamento de alguns arquivos &#8220;inocentes&#8221; fosse prejudicado com falsas sinalizações.</p><p>Agora, além de impedir o compartilhamento de arquivos que supostamente ferem sua política, a empresa avisará aos proprietários (por email) quando os itens armazenados no Drive forem sinalizados.</p><div class="wp-block-image"><figure class="aligncenter size-large"><a href="https://macmagazine.com.br/wp-content/uploads/2021/12/15-email-google.png"><img width="1260" height="672" src="https://macmagazine.com.br/wp-content/uploads/2021/12/15-email-google-1260x672.png" alt="Email enviado pelo Google" class="wp-image-841496" srcset="https://macmagazine.com.br/wp-content/uploads/2021/12/15-email-google-1260x672.png 1260w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-email-google-600x320.png 600w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-email-google-300x160.png 300w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-email-google-1536x819.png 1536w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-email-google-2048x1092.png 2048w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-email-google-380x203.png 380w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-email-google-800x427.png 800w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-email-google-1160x619.png 1160w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-email-google-1920x1024.png 1920w, https://macmagazine.com.br/wp-content/uploads/2021/12/15-email-google.png 2224w" sizes="(max-width: 1260px) 100vw, 1260px" /></a></figure></div><p>Funcionará assim: quando um arquivo for detectado como suspeito, ele ganhará uma bandeira sinalizando que há algo de errado e será restrito, mas não excluído por completo. Isso significa que apenas o proprietário conseguirá acessá-lo, mas o item não poderá ser compartilhado e não ficará visível nem mesmo para as pessoas que já tiverem acesso ao link.</p><p>Além disso, como já mencionado, o dono desse arquivo receberá um email com detalhes e possíveis medicas que poderão ser tomadas para que seja solicitada uma revisão.</p><p>De acordo com o Google, isso ajudará a garantir que os proprietários desses itens no Google Drive estejam totalmente informados sobre o status dos seus arquivos e, ao mesmo tempo, garantirá que outros usuários estejam protegidos contra conteúdos abusivos.</p><hr /><div class="appbox"><div class="appbox-icon"><a href="https://apps.apple.com/br/app/google-drive-armazenamento/id507874739" target="_blank"><img class="appbox-iconiOS" alt="&Iacute;cone do app Google Drive - armazenamento" src="https://is2-ssl.mzstatic.com/image/thumb/Purple116/v4/bb/d9/d6/bbd9d687-6161-870c-d843-3be99480f039/AppIcon-0-1x_U007emarketing-0-6-0-0-0-85-220.png/256x256bb.png" /></a></div><div class="appbox-details"><span class="appbox-name"><a href="https://apps.apple.com/br/app/google-drive-armazenamento/id507874739" target="_blank">Google Drive - armazenamento</a></span><span class="appbox-de">de <strong><a href="http://drive.google.com/start" target="_blank" class="no_icon" rel="nofollow">Google LLC</a></strong></span><div class="appbox-devices"><img src="https://macmagazine.com.br/wp-content/uploads/2015/11/devices_ipad.png" alt="Compat&iacute;vel com iPads" title="Compat&iacute;vel com iPads" class="appbox-devicesiPad" /><img src="https://macmagazine.com.br/wp-content/uploads/2015/11/devices_iphone.png" alt="Compat&iacute;vel com iPhones" title="Compat&iacute;vel com iPhones" class="appbox-devicesiPhone" /></div><div class="appbox-info">Vers&atilde;o <strong>4.2021.48202</strong> (238.9 MB)<br />
                    Requer o <strong>iOS 13.0</strong> ou superior</div></div><div class="appbox-badge"><span class="appbox-price">Gr&aacute;tis</span><span><a href="https://apps.apple.com/br/app/google-drive-armazenamento/id507874739" target="_blank"><img alt="Badge - Baixar na App Store" src="https://macmagazine.com.br/wp-content/uploads/2017/11/22-badge_appstore.png" class="badgeInvert" /></a></span><span class="appbox-QRcode"><a href="javascript:void(0);" title="C&oacute;digo QR - Google Drive - armazenamento" onclick="javascript:abrirQR('https://chart.googleapis.com/chart?chs=400x400&cht=qr&chl=https%3A%2F%2Fapps.apple.com%2Fbr%2Fapp%2Fgoogle-drive-armazenamento%2Fid507874739&chld=L|0');return false;"><img alt="C&oacute;digo QR" src="https://macmagazine.com.br/wp-content/themes/newsblock-child/images/qr.png" /></a><a href="javascript:void(0);" title="C&oacute;digo QR - Google Drive - armazenamento" onclick="javascript:abrirQR('https://chart.googleapis.com/chart?chs=400x400&cht=qr&chl=https%3A%2F%2Fapps.apple.com%2Fbr%2Fapp%2Fgoogle-drive-armazenamento%2Fid507874739&chld=L|0');return false;">C&oacute;digo QR</a></span></div>
                </div><p><span class="credito">via <a href="https://www.androidpolice.com/google-drive-will-inform-you-when-your-file-violates-its-policies/">Android Police</a></span></p>
]]>
</content:encoded>
<wfw:commentRss>https://macmagazine.com.br/post/2021/12/15/google-drive-alertara-sobre-arquivos-marcados-como-spam/feed/</wfw:commentRss>
<slash:comments>0</slash:comments>
<post-id xmlns="com-wordpress:feed-additions:1">841480</post-id>
<media:content xmlns:media="http://search.yahoo.com/mrss/" medium="image" type="image/jpeg" url="https://macmagazine.com.br/wp-content/uploads/2020/10/06-Google-Workspace-1260x525.png" width="1200" height="500" />
</item>
</channel>
</rss>
"""

    var posts: Data? {
        return Data(example.utf8)
    }
}
