package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.PortCap_xsContext;

public class PortCap_xsContextExt extends AbstractBaseExt {

	public PortCap_xsContextExt(PortCap_xsContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public PortCap_xsContext getContext() {
		return (PortCap_xsContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).portCap_xs());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof PortCap_xsContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + PortCap_xsContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
