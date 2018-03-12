package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.PortCap_dContext;

public class PortCap_dContextExt extends AbstractBaseExt {

	public PortCap_dContextExt(PortCap_dContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public PortCap_dContext getContext() {
		return (PortCap_dContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).portCap_d());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof PortCap_dContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + PortCap_dContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
