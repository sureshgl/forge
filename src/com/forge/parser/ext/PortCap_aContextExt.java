package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.PortCap_aContext;

public class PortCap_aContextExt extends AbstractBaseExt {

	public PortCap_aContextExt(PortCap_aContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public PortCap_aContext getContext() {
		return (PortCap_aContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).portCap_a());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof PortCap_aContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + PortCap_aContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
