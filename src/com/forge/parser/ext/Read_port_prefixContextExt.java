package com.forge.parser.ext;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.tree.TerminalNode;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Port_prefix_muxContext;
import com.forge.parser.gen.ForgeParser.Read_port_prefixContext;

public class Read_port_prefixContextExt extends AbstractBaseExt {

	public Read_port_prefixContextExt(Read_port_prefixContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Read_port_prefixContext getContext() {
		return (Read_port_prefixContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).read_port_prefix());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Read_port_prefixContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Read_port_prefixContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	@Override
	protected List<String> getPortConnections(String name, Boolean banked) {
		Read_port_prefixContext ctx = getContext();
		Map<String, List<String>> prefixes = new LinkedHashMap<>();
		for (Port_prefix_muxContext port_prefix_muxContext : ctx.port_prefix_list().port_prefix_mux()) {
			List<String> suffixes = new ArrayList<>();
			for (TerminalNode node : port_prefix_muxContext.Decimal_number()) {
				suffixes.add(node.getText());
			}
			prefixes.put(port_prefix_muxContext.port_prefix_identifier().extendedContext.getFormattedText(), suffixes);
		}
		return getConnections(prefixes, name, banked);
	}

	private List<String> getConnections(Map<String, List<String>> prefixes, String name, Boolean banked) {
		List<String> connections = new ArrayList<>();
		connections.add(getConnection("_read", "_re_r", name, prefixes));
		if (banked) {
			connections.add(getConnection("_rd_radr", "_ar_r", name, prefixes));
			connections.add(getConnection("_rd_badr", "_ab_r", name, prefixes));
		} else {
			connections.add(getConnection("_rd_adr", "_a_r", name, prefixes));
		}
		connections.add(getConnection("_rd_dout", "_dout_r", name, prefixes));
		return connections;
	}

	private String getConnection(String p1, String p2, String name, Map<String, List<String>> prefixes) {
		String ret = "." + name + p1 + "(";
		String in = "{";
		for (String prefix : prefixes.keySet()) {
			if (prefixes.get(prefix).size() > 0) {
				for (String suffix : prefixes.get(prefix)) {
					in += prefix + p2 + suffix;
					prefix = "," + prefix;
				}
			} else {
				in += prefix + p2 + "0";
			}
			prefix = "," + prefix;
		}
		in += "}";
		ret += in + ")";
		return ret;
	}
}
