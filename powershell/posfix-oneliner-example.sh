curl -s https://www.myharvardclassics.com/categories/20120212 \
| grep "downloads.*download" | sed -e 's/href/\n&/g' \
| sed 's/.*\(http:.*download\)/\1/g' | grep " - " \
| grep -v target | sed 's/"> - / /g' | sed 's/<.*//g' \
| while read link rest; do \
	if [ "${i}" = "" ]; then i=1; fi; \
	wget -O "Harvard Classics - Volume $(printf '%02d' ${i}) - ${rest}.pdf" "${link}"; \
	i=$(( i + 1 )); \
  done