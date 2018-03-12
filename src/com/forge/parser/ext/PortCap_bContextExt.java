package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.PortCap_bContext;

public class PortCap_bContextExt extends AbstractBaseExt {

	public PortCap_bContextExt(PortCap_bContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public PortCap_bContext getContext() {
		return (PortCap_bContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).portCap_b());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof PortCap_bContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + PortCap_bContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
