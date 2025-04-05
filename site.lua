return {
	namespaces = {
		[0] = { id=0,	name="" },
		
		[1] = { id=1,	name="Talk" },
		[2] = { id=2,	name="User" },
		[3] = { id=3,	name="User talk" },
		[4] = { id=4,	name="Project" },
		[5] = { id=5,	name="Project talk" },
		[6] = { id=6,	name="File" },
		[7] = { id=7,	name="File talk" },
		[8] = { id=8,	name="MediaWiki" },
		[9] = { id=9,	name="MediaWiki talk" },
		[10] = { id=10,	name="Template" },
		[11] = { id=11,	name="Template talk" },
		[12] = { id=12,	name="Help" },
		[13] = { id=13,	name="Help talk" },
		[14] = { id=14,	name="Category" },
		[15] = { id=15,	name="Category talk" },

		-- (\d+)\s+([^\t\n]+)\t([^\t\n]+[^ \t])\s+(\d+)
		-- [$1] = { id=$1,	name="$2" },\n\t\t[$4] = { id=$4,	name="$3" },
		[100] = { id=100,	name="Portal" },
		[101] = { id=101,	name="Portal talk" },
		[118] = { id=118,	name="Draft" },
		[119] = { id=119,	name="Draft talk" },
		[126] = { id=126,	name="MOS" },
		[127] = { id=127,	name="MOS talk" },
		[710] = { id=710,	name="TimedText" },
		[711] = { id=711,	name="TimedText talk" },
		[828] = { id=828,	name="Module" },
		[829] = { id=829,	name="Module talk" },
		[1728] = { id=1728,	name="Event" },
		[1729] = { id=1729,	name="Event talk" },

		[-2] = { id=-2,	name="Media" },
		[-1] = { id=-1,	name="Special" }
	}
}
