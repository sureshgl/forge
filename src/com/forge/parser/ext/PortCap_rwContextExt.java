package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.PortCap_rwContext;

public class PortCap_rwContextExt extends AbstractBaseExt {

	public PortCap_rwContextExt(PortCap_rwContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public PortCap_rwContext getContext() {
		return (PortCap_rwContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).portCap_rw());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof PortCap_rwContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + PortCap_rwContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
