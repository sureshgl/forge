package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.PortCap_lContext;

public class PortCap_lContextExt extends AbstractBaseExt {

	public PortCap_lContextExt(PortCap_lContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public PortCap_lContext getContext() {
		return (PortCap_lContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).portCap_l());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof PortCap_lContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + PortCap_lContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
