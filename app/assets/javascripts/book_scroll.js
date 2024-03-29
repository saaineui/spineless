 /*
  * BookScroll
  * ============
  * module for cleanly reflowing and scrolling a book chapter
  * bundled in application.js
  */
        var BookScroll = (function() {

            var FALLBACK_LINE_HEIGHT = 30;
            var FALLBACK_STICKY_BAR_HEIGHT = 41;
            var WRAPPER_PADDING = 16; // #wrapper div padding
            var SCROLL_WRAP_MARGIN = 16; // #scroll-wrap div margin
            var NEXT_BACK_MARGIN = 30; // footer height to clear
            var data;

            function round(number, precision) {
              var factor = Math.pow(10, precision);
              var tempNumber = Math.round(number * factor);
              return tempNumber / factor;
            };

            function initialize_data(d) {
                data = Object.assign({}, d);
            }

            // grab line_height and scroll_interval from dom - call within load
            function initialize_height_props() {
                data.line_height = get_line_height(); // 1

                var sticky_bar_height = get_sticky_bar_height(); // 2
                var all_vertical_padding = sticky_bar_height + WRAPPER_PADDING + SCROLL_WRAP_MARGIN + NEXT_BACK_MARGIN; // 3
                var box_height = $(window).height() - all_vertical_padding; // 4
                data.scroll_interval = box_height - (box_height % data.line_height); // 5
            }

            function update(prop, value) {
                data[prop] = value;
            }

            function update_progress_bar() {
                var progress = compute_section_progress() + data.progress_start;
                $("#progress").css("width", progress + "%");
                $("#progress-percent").text( Math.floor(progress) + "%" );
            }

            function update_bookmark_links() {
                var scroll_param = "scroll=" + safe_scroll(data.anchor, data.max_clicks);

                var bookmark = $("#bookmark").attr("href").replace(/\?scroll=[0-9]*_*[0-9]*/, "")+"?"+scroll_param;
                $("#bookmark").attr("href", bookmark);

                if ($("#new-bookmark").length > 0) {
                    var new_bookmark = $("#new-bookmark").attr("href").replace(/scroll=[0-9]*_*[0-9]*/, scroll_param);
                    $("#new-bookmark").attr("href", new_bookmark);
                }
            }

            function update_anchor_and_max_clicks() {
                data.max_clicks = compute_max_clicks();
                data.anchor = compute_anchor();
            }

            // get line height from paragraph or h2 tag; fallback to hard-coded value
            function get_line_height() {
                if ($('#ebook h2').length > 0) {
                    return parseInt( $('#ebook h2').css('line-height') ) / 2;
                }
                if ($('#ebook p').length > 0) {
                    return parseInt( $('#ebook p').css('line-height') );
                }
                return FALLBACK_LINE_HEIGHT;
            }

            // get sticky_bar_height from sticky bar nav tag; fallback to hard-coded value
            function get_sticky_bar_height() {
                if ($('#sticky-bar > nav').length > 0) {
                    return parseInt( $("#sticky-bar > nav").height() );
                }
                return FALLBACK_STICKY_BAR_HEIGHT;
            }

            // compute accrued progress points for current section
            function compute_section_progress() {
                return data.anchor * data.section_progress_points / (data.max_clicks + 1);
            }

            // scroll string with underscore for decimal point
            function safe_scroll(anchor, max_clicks) {
                return compute_scroll(anchor, max_clicks).toString().replace('.', '_');
            }

            // compute scroll value (integer) for an anchor and max_clicks pair
            function compute_scroll(anchor, max_clicks) {
                return round(anchor * 100.0 / (max_clicks + 1), 2);
            }

            // compute anchor (zero index for which page we are on) from scroll
            function compute_anchor() {
                if (!is_multipage()) { return 0; } // short pages have no scroll

                normalize_scroll();

		var est_anchor = estimated_anchor();
                var scroll_diff = compute_scroll(est_anchor, data.max_clicks) - data.scroll;

                if (scroll_diff === 0) { return est_anchor; } // exact match found

                var scroll_diff_next_anchor = compute_scroll(est_anchor + 1, data.max_clicks) - data.scroll;

                if (est_anchor == data.max_clicks || Math.abs(scroll_diff) < Math.abs(scroll_diff_next_anchor)) {
                    return est_anchor;
                } else {
                    return est_anchor + 1;
                }
            }

	    function estimated_anchor() {
	        return Math.floor((data.content_height * data.scroll * 0.01) / data.scroll_interval);
	    }

	    function normalize_scroll() {
		if (data.scroll < 0) {
		    update('scroll', 0);
		} else if (estimated_anchor() > data.max_clicks) {
		    update('scroll', compute_scroll(data.max_clicks, data.max_clicks));
		}
            }

            // compute upper bound for scroll
            function compute_max_clicks(){
                if (!is_multipage()) { return 0; } // short pages have no scroll

                if (data.content_height % data.scroll_interval == 0) { // special handling for full height last page
                    return data.content_height / data.scroll_interval - 1;
                } else {
                    return Math.floor(data.content_height / data.scroll_interval);
                }
            }

            function is_top_or_bottom(anchor_increment) {
                return is_top(anchor_increment) || is_bottom(anchor_increment);
            }

            function is_top(anchor_increment) {
                return anchor_increment < 0 && data.anchor === 0;
            }

            function is_bottom(anchor_increment) {
                return anchor_increment > 0 && data.anchor === data.max_clicks;
            }

            function is_multipage() {
                return data.content_height > data.scroll_interval;
            }

            return {
                // retrieve data object
                data: function() {
                    return data;
                },

                // is a bookmarked link or other prescrolled page
                is_prescrolled_page: function() {
                    return data.anchor > 0;
                },

                // scroll anchor_increment
                get_anchor_increment: function(nav_btn){
                    return $(nav_btn).hasClass("up") ? -1 : 1;
                },

                // scroll one page up or down and update progress bar and bookmark links
                scroll_page: function(anchor_increment){
                    if (is_top_or_bottom(anchor_increment)) {
                        return false; // return early if at top or bottom of chapter
                    }

                    update('anchor', data.anchor + anchor_increment);
                    $("#ebook").animate({ marginTop: -1 * (data.scroll_interval * data.anchor) + "px" }, 150);

                    update_progress_bar();
                    update_bookmark_links();
                },

                // prescroll page to computed anchor
                prescroll_page: function(){
                    $("#ebook").css("margin-top", -1 * (data.scroll_interval * data.anchor) + "px");
                },

                // expose some private methods
                compute_anchor: compute_anchor,
                compute_max_clicks: compute_max_clicks,
                compute_scroll: compute_scroll,
                get_line_height: get_line_height,
                get_sticky_bar_height: get_sticky_bar_height,
                initialize_data: initialize_data,
                initialize_height_props: initialize_height_props,
                is_multipage: is_multipage,
                update: update,
                update_anchor_and_max_clicks: update_anchor_and_max_clicks,
                update_bookmark_links: update_bookmark_links,
                update_progress_bar: update_progress_bar
            };

        })();
