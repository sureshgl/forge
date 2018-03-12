package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Port_prefix_muxContext;

public class Port_prefix_muxContextExt extends AbstractBaseExt {

	public Port_prefix_muxContextExt(Port_prefix_muxContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Port_prefix_muxContext getContext() {
		return (Port_prefix_muxContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).port_prefix_mux());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Port_prefix_muxContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Port_prefix_muxContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
